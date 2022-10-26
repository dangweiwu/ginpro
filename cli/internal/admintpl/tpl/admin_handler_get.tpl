package handler

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/router/irouter"
	"{{.Module}}/internal/serctx"
	"gs/api/hd"
	"gs/api/query"

	"github.com/gin-gonic/gin"
)

type AdminGet struct {
	*hd.Hd
	ctx *gin.Context
	sc  *serctx.ServerContext

}

func NewAdminGet(ctx *gin.Context, sc *serctx.ServerContext) irouter.IHandler {
	return &AdminGet{hd.NewHd(ctx),ctx, sc}
}

func (this *AdminGet) Do() error {
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

func (this *AdminGet) Query() (interface{}, error) {
	po := &adminmodel.AdminPo1{}
	pos := []adminmodel.AdminPo1{}
	q := query.NewQuery(this.ctx, this.sc.Db, QueryRule, po, &pos)
	return q.Do()
}