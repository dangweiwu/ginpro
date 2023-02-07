package api

import (
	"{{.Module}}/internal/app/role/rolemodel"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/router/irouter"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"{{.Host}}/api/hd"
	"{{.Host}}/api/query"
)

type RoleQuery struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewRoleQuery(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &RoleQuery{hd.NewHd(c), c, sc}
}

//	@tags		角色管理
//	@summary	查询角色
//	@router		/api/role [get]
//	@param		code	query		string									false	"角色编码"
//	@param		name	query		string									false	"角色名称"
//	@success	200		{object}	query.PageData{data=[]rolemodel.RolePo}	"ok"
func (this *RoleQuery) Do() error {

	data, err := this.Query()
	if err != nil {
		return err
	} else {
		this.Rep(data)
		return nil
	}
}

var QueryRule = map[string]string{
	"code": "like",
	"name": "like",
}

func (this *RoleQuery) Query() (interface{}, error) {
	po := &rolemodel.RolePo{}
	pos := []rolemodel.RolePo{}
	q := query.NewQuery(this.ctx, this.sc.Db, QueryRule, po, &pos)
	q.SetOrder(func(db *gorm.DB) (r *gorm.DB) {
		db = db.Order("order_num")
		return db
	})
	return q.Do()
}
