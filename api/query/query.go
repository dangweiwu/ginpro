package query

/*
@Time : 2021/7/28 21:42
@Author : dang
@desz:
基于 mysql gorm 检索
支持 模糊和精确查询
支持 分页查询
支持 排序 order by
使用说明

page := NewQuery(ctx,rule,po,pos)
1. 修改where 一旦定义则默认失效
page.SetWhere(func(db *gorm.Db){
	if start,has:=page.QData["start"];has{
		delete data.QData["start"]
		db = db.Where("created_at > ?",start)
	}
	if end,has := page.QData["end"];has{
		delete data.QData["end"]
		db = db.Where("created_at < ?",end)
	}
	return page.Where(db)
})

2. 修改Order 一旦定义则默认失效
前端 传递 od=created_at desc,id
page.SetOrder(func(db *gorm.Db){
	return db.Order("id desc")
})

3. page 失效
page.ClearPage()
*/
import (
	// "admin/internal/app_pkg/mysql"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

const ORDER = "od"

type QueryResult struct {
	Page *Page       `json:"page"`
	Data interface{} `json:"data"`
}

type QueryAllResult struct {
	Data interface{}
}

type DbCallBack func(db *gorm.DB) (r *gorm.DB)

type Query struct {
	db       *gorm.DB
	LikeData map[string]string //模糊查询参数
	QData    map[string]string //查询参数
	Po       interface{}       //库po
	Pos      interface{}       //库&pos
	OrderStr string
	OrderF   DbCallBack
	WhereF   DbCallBack
	Page     *Page
}

func NewQuery(ctx *gin.Context, db *gorm.DB, rule map[string]string, po interface{}, pos interface{}) *Query {
	a := &Query{}
	a.Pos = pos
	a.db = db
	a.Po = po
	a.Page = ParsePage(ctx)
	a.LikeData, a.QData = ParseQuery(ctx, rule)
	a.OrderStr = ctx.Query("od")
	return a
}

func (this *Query) ClearPage() {
	this.Page = nil
}

// order 定制
func (this *Query) SetOrder(f DbCallBack) {
	this.OrderF = f
}

// where 订制
func (this *Query) SetWhere(f DbCallBack) {
	this.WhereF = f
}

// 默认where
func (this *Query) Where(r *gorm.DB) *gorm.DB {
	if len(this.QData) != 0 {
		r = r.Where(this.QData)
	}
	for k, v := range this.LikeData {
		r = r.Where(k+" like ?", "%"+v+"%")
	}
	return r
}

func (this *Query) GetResult() interface{} {
	if this.Page == nil {
		return &QueryAllResult{this.Pos}
	} else {
		return &QueryResult{this.Page, this.Pos}
	}
}

func (this *Query) Do() (interface{}, error) {

	//3.1 数据库查询
	r := this.db.Model(this.Po)

	//where
	if this.WhereF != nil {
		//被定制则使用定制where
		r = this.WhereF(r)
	} else {
		r = this.Where(r)
	}

	//order
	if this.OrderF != nil {
		r = this.OrderF(r)
	} else if this.OrderStr != "" {
		r = r.Order(this.OrderStr)
	} else {
		r = r.Order("created_at desc")
	}
	//3.2 配合page
	if this.Page != nil {
		count := int64(0)
		r.Count(&count)
		this.Page.Total = int(count)
		offset := (this.Page.Current - 1) * this.Page.Limit
		r = r.Offset(offset).Limit(this.Page.Limit)
	}
	r = r.Find(this.Pos)
	if r.Error != nil {
		return nil, r.Error
	} else {
		return this.GetResult(), nil
	}
}
