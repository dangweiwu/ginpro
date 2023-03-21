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

// @tags		权限管理
// @summary	获取所有url
// @router		/api/allurl [get]
// @success	200	{object}	hd.Response{data=[]string}
func (this *GetFullUrl) Do() error {
	this.Hd.Rep(hd.Response{fullurl.NewFullUrl().GetUrl()})
	return nil
}