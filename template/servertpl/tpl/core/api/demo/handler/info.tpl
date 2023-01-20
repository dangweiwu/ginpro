package handler

import (
	"{{.Module}}/internal/ctx"
	"github.com/gin-gonic/gin"
	"{{.Host}}/api/hd"
	"{{.Module}}/internal/router/irouter"
)


type DemoInfo struct {
	*hd.Hd
	c *gin.Context
	sc  *ctx.ServerContext
}

func NewDemoInfo(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &DemoInfo{hd.NewHd(c), c, sc}
}

func (this *DemoInfo) Do() error {
	this.Rep(map[string]string{"data": "hello word"})
	return nil
}
