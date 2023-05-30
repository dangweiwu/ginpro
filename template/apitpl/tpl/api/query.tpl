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

// @x-group		{"key":"{{.ApiName}}","inorder":4}
//	@summary	查询{{.ApiName}}
//	@router		/api/{{.RouterUrl}} [get]
//  @param      Authorization header   string                 true " " extensions(x-name=鉴权,x-value=[TOKEN])
//  @param      limit query    string          false " "  extensions(x-name=分页条数,x-value=10)
//  @param      current query    string        false " "  extensions(x-name=页码,x-value=1)
//	@param		[参数变量1]	query		string	false	" "  extensions(x-name=,x-value=)
//	@success	200		{object}	{{.ModelPackage}}.{{.ModelName}}Vo	" "
func (this *{{.ApiName}}Query) Do() error {

	data,err := this.Query()
	if err != nil {
		return err
	} else {
		this.Rep(data)
		return nil
	}
}


func (this *{{.ApiName}}Query) Query() (interface{}, error) {
	vo := &{{.ModelPackage}}.{{.ModelName}}Vo{}
	vos := []{{.ModelPackage}}.{{.ModelName}}Vo{}
	q := query.NewQuery(this.ctx, this.sc.Db, {{.ModelPackage}}.QueryRule, vo, &vos)
	return q.Do()
}