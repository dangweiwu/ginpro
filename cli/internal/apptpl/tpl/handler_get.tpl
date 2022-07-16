package handler

import (
	"github.com/gin-gonic/gin"
	"gs/api/hd"
	"gs/api/query"
	"{{.Module}}/internal/serctx"
	"{{.Module}}/internal/app/{{.AppPackage}}/{{.ModelPackage}}"
	"{{.Module}}/internal/router/irouter"	
)


type {{.AppName}}Get struct {
    ctx    *gin.Context
	serctx *serctx.ServerContext
}

func New{{.AppName}}Get(ctx *gin.Context,serCtx *serctx.ServerContext) irouter.IHandler {
	return &{{.AppName}}Get{ctx, serCtx}
}

func (this *{{.AppName}}Get) Do() error {

	data,err := this.Query()
	if err != nil {
		return err
	} else {
		hd.Rep(this.ctx, data)
		return nil
	}
}

var QueryRule = map[string]string{
	key:"like" or ""
}

func (this *{{.AppName}}Get) Query() (interface{}, error) {
	po := &{{.ModelPackage}}.{{.ModelName}}{}
	pos := []{{.ModelPackage}}.{{.ModelName}}{}
	q := query.NewQuery(this.ctx, this.serctx.Db, QueryRule, po, &pos)
	return q.Do()
}