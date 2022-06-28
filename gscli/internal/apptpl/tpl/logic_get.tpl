package logic

import (
	"{{.Module}}/internal/serctx"
	"{{.Module}}/internal/app/{{.AppPackage}}/{{.ModelPackage}}"
	"github.com/gin-gonic/gin"
	"gs/api/query"
)

type {{.AppName}}Get struct {
    ctx    *gin.Context
	serctx *serctx.ServerContext
}

func New{{.AppName}}Get(ctx *gin.Context,serCtx *serctx.ServerContext) *{{.AppName}}Get {
	return &{{.AppName}}Get{ctx, serCtx}
}

var QueryRule = map[string]string{
	key:"like" or ""
}

func (this *{{.AppName}}Get) Query() (interface{}, error) {
	po := &{{.ModelPackage}}.{{.ModelName}}{}
	pos := []{{.ModelPackage}}.{{.ModelName}}{}
	q := query.NewQuery(this.ctx, this.serctx.Db, po, &pos)
	q.QueryWhere(QueryRule)
	return q.GetPage()
}