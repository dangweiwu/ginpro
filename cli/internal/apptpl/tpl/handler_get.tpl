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
	*hd.Hd
    ctx *gin.Context
	sc  *serctx.ServerContext
}

func New{{.AppName}}Get(ctx *gin.Context,sc *serctx.ServerContext) irouter.IHandler {
	return &{{.AppName}}Get{hd.NewHd(ctx),ctx, sc}
}

func (this *{{.AppName}}Get) Do() error {

	data,err := this.Query()
	if err != nil {
		return err
	} else {
		this.Rep(data)
		return nil
	}
}

var QueryRule = map[string]string{
	//	key:"like"  or ""
}

func (this *{{.AppName}}Get) Query() (interface{}, error) {
	po := &{{.ModelPackage}}.{{.ModelName}}{}
	pos := []{{.ModelPackage}}.{{.ModelName}}{}
	q := query.NewQuery(this.ctx, this.sc.Db, QueryRule, po, &pos)
	return q.Do()
}