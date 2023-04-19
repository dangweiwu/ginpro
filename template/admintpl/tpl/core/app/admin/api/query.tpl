package api

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/router/irouter"
	"{{.Module}}/internal/ctx"
	"{{.Host}}/api/hd"
	"{{.Host}}/api/query"
	"github.com/gin-gonic/gin"
)

type AdminQuery struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewAdminQuery(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &AdminQuery{hd.NewHd(c), c, sc}
}

// @tags    系统用户
// @summary 查询用户
// @router  /api/admin [get]
// @param   account query    string                                     false "账号 "
// @param   phone   query    string                                     false "手机号"
// @param   email   query    string                                     false "email"
// @param   name    query    string                                     false "姓名"
// @success 200     {object} query.PageData{data=[]adminmodel.AdminVo} "ok"
func (this *AdminQuery) Do() error {
	data, err := this.Query()
	if err != nil {
		return err
	} else {
		this.Rep(data)
		return nil
	}
}

var QueryRule = map[string]string{
	"account": "like",
	"phone":   "like",
	"email":   "like",
	"name":    "like",
}

func (this *AdminQuery) Query() (interface{}, error) {
	po := &adminmodel.AdminVo{}
	pos := []adminmodel.AdminVo{}
	q := query.NewQuery(this.ctx, this.sc.Db, QueryRule, po, &pos)
	return q.Do()
}
