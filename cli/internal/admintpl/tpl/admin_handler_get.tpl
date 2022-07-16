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
	ctx    *gin.Context
	serctx *serctx.ServerContext
}

func NewAdminGet(ctx *gin.Context, serCtx *serctx.ServerContext) irouter.IHandler {
	return &AdminGet{ctx, serCtx}
}

func (this *AdminGet) Do() error {
	data, err := this.Query()
	if err != nil {
		return err
	} else {
		hd.Rep(this.ctx, data)
		return nil
	}
}

var QueryRule = map[string]string{
	"Account": "like",
	"Phone":   "like",
	"Email":   "like",
	"Name":    "like",
}

func (this *AdminGet) Query() (interface{}, error) {
	po := &adminmodel.AdminPo1{}
	pos := []adminmodel.AdminPo1{}
	q := query.NewQuery(this.ctx, this.serctx.Db, QueryRule, po, &pos)
	return q.Do()
}
