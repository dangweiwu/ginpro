package api

import (
	"github.com/gin-gonic/gin"
	"{{.Host}}/api/hd"
	"{{.Host}}/api/query"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/app/{{.ApiPackage}}/{{.ModelPackage}}"
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

//	@tags		主题{{.ApiName}}
//	@summary	查询{{.ApiName}}
//	@router		/api/{{.RouterUrl}} [get]
//	@param		[参数变量1]	query		string										false	"[参数名1]"
//	@param		[参数变量2]	query		string										false	"[参数名2]"
//	@success	200		{object}	query.PageData{data=[]{{.ModelPackage}}.{{.ModelName}}Vo}	"ok"
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
	vo := &{{.ModelPackage}}.{{.ModelName}}Vo{}
	vos := []{{.ModelPackage}}.{{.ModelName}}Vo{}
	q := query.NewQuery(this.ctx, this.sc.Db, QueryRule, vo, &vos)
	return q.Do()
}