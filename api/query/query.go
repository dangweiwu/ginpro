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
	Page *Page
	Data interface{}
}

type QueryAllResult struct {
	Data interface{}
}

type Query struct {
	ctx  *gin.Context
	db   *gorm.DB
	Po   interface{} //库po
	Pos  interface{} //库&pos
	Page *Page
}

func NewQuery(ctx *gin.Context, db *gorm.DB, po interface{}, pos interface{}) *Query {

	a := &Query{}
	a.ctx = ctx
	a.Pos = pos
	a.db = db.Model(po)
	a.Po = po

	return a
}

func (this *Query) GetDb() *gorm.DB {
	return this.db
}

//默认where
func (this *Query) QueryWhere(rule map[string]string) {
	LikeData, QData := ParseQuery(this.ctx, rule)
	if len(QData) != 0 {
		this.db = this.db.Where(QData)
	}
	for k, v := range LikeData {
		this.db = this.db.Where(k+" like ?", "%"+v+"%")
	}
}

func (this *Query) getResult() interface{} {
	if this.Page == nil {
		return &QueryAllResult{this.Pos}
	} else {
		return &QueryResult{this.Page, this.Pos}
	}
}

//带分页参数
func (this *Query) GetPage() (interface{}, error) {

	this.Page = ParsePage(this.ctx)
	count := int64(0)
	this.db.Count(&count)
	this.Page.Total = int(count)
	offset := (this.Page.Current - 1) * this.Page.Limit
	this.db = this.db.Offset(offset).Limit(this.Page.Limit)

	r := this.db.Find(this.Pos)

	if r.Error != nil {
		return nil, r.Error
	} else {
		return this.getResult(), nil
	}
}

//不带分页参数
func (this *Query) GetData() (interface{}, error) {
	r := this.db.Find(this.Pos)

	if r.Error != nil {
		return nil, r.Error
	} else {
		return this.getResult(), nil
	}
}
