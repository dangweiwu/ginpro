package api

import (
	"github.com/gin-gonic/gin"
    "{{.Module}}/internal/pkg/api/hd"
	"{{.Module}}/internal/pkg/api/query"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/app/{{.ApiPackage}}/{{.ModelPackage}}"
	"{{.Module}}/internal/router/irouter"	
)


type {{.ApiName}}Query struct {
	*hd.Hd
    ctx *gin.Context
	appctx  *ctx.AppContext
}

func New{{.ApiName}}Query(c *gin.Context,appctx *ctx.AppContext) irouter.IHandler {
	return &{{.ApiName}}Query{hd.NewHd(c),c, appctx}
}

// Do
// @api 	| {{.ApiName}} | 3 | 查询{{.ApiName}}
// @path 	| /api/{{.RouterUrl}}
// @method 	| GET
// @header 	|n Authorization |d token |e tokenstring |c 鉴权 |t string
// @query   |n limit   |d 条数 |e 10 |t int
// @query   |n current |d 页码 |e 1  |t int
// @query 	|n demo |d demo |e demo | t string
// @response | query.QueryResult | 200 Response
// @response | query.Page | Page定义
// @response | {{.ModelPackage}}.{{.ModelName}}Vo | []Data 定义
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
	q := query.NewQuery(this.ctx, this.appctx.Db, {{.ModelPackage}}.QueryRule, vo, &vos)
	return q.Do()
}