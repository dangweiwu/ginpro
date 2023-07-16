package api

import (
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/pkg/fullurl"
	"{{.Module}}/internal/router/irouter"
	"github.com/gin-gonic/gin"
	"{{.Host}}/api/hd"
)

/*
获取全部url
*/
type GetFullUrl struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewGetFullUrl(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &GetFullUrl{hd.NewHd(c), c, sc}
}

//	@tags			权限管理
//	@summary		获取所有url
//	@description	获取所有接口api，创建接口权限用
//	@x-group		{"key":"auth","inorder":5}
//	@router			/api/allurl [get]
//	@param			Authorization	header		string	true	" "	extensions(x-name=鉴权,x-value=[TOKEN])
//	@success		200				{string}	string	"{data:[api1,....]}"
func (this *GetFullUrl) Do() error {
	this.Hd.Rep(hd.Response{fullurl.NewFullUrl().GetUrl()})
	return nil
}
