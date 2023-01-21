package handler

import (
	"github.com/gin-gonic/gin"
	"{{.Host}}/api/hd"
	"{{.Host}}/api/query"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/api/{{.ApiPackage}}/{{.ModelPackage}}"
	"{{.Module}}/internal/router/irouter"	
)


type {{.ApiName}}Query struct {
	*hd.Hd
    ctx *gin.Context
	sc  *ctx.ServerContext
}

func New{{.ApiName}}Query(c *gin.Context,sc *ctx.ServerContext) irouter.IHandler {
	return &{{.ApiName}}Query{hd.NewHd(c),c, sc}
}

func (this *{{.ApiName}}Query) Do() error {

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

func (this *{{.ApiName}}Query) Query() (interface{}, error) {
	po := &{{.ModelPackage}}.{{.ModelName}}{}
	pos := []{{.ModelPackage}}.{{.ModelName}}{}
	q := query.NewQuery(this.ctx, this.sc.Db, QueryRule, po, &pos)
	return q.Do()
}