package logic

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/serctx"
	"gs/api/query"

	"github.com/gin-gonic/gin"
)

type AdminGet struct {
	ctx    *gin.Context
	serctx *serctx.ServerContext
}

func NewAdminGet(ctx *gin.Context, serCtx *serctx.ServerContext) *AdminGet {
	return &AdminGet{ctx, serCtx}
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
	q := query.NewQuery(this.ctx, this.serctx.Db, po, &pos)
	q.QueryWhere(QueryRule)
	return q.GetPage()
}
