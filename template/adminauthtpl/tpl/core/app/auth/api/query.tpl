package api

import (
	"{{.Module}}/internal/app/auth/authmodel"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/router/irouter"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"{{.Host}}/api/hd"
	"{{.Host}}/api/query"
)

type AuthQuery struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewAuthQuery(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &AuthQuery{hd.NewHd(c), c, sc}
}

//	@tags		权限管理
//	@summary	查询权限
//	@router		/api/auth [get]
//	@param		name	query		string									false	"权限"
//	@param		code	query		string									false	"编码"
//	@param		api		query		string									false	"api"
//	@param		kind	query		string									false	"类型 0 按钮 1 页面"
//	@success	200		{object}	query.PageData{data=[]authmodel.AuthPo}	"ok"
func (this *AuthQuery) Do() error {

	data, err := this.Query()
	if err != nil {
		return err
	} else {
		this.Rep(data)
		return nil
	}
}

var QueryRule = map[string]string{
	"name": "like",
	"code": "like",
	"api":  "like",
	"kind": "like",
}

func (this *AuthQuery) Query() (interface{}, error) {
	po := &authmodel.AuthPo{}
	pos := []authmodel.AuthPo{}
	q := query.NewQuery(this.ctx, this.sc.Db, QueryRule, po, &pos)
	q.SetOrder(func(db *gorm.DB) (r *gorm.DB) {
		return db.Order("order_num")
	})
	return q.Do()
}
