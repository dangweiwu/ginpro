package router

import (
	"{{.Module}}/internal/ctx"
	"{{.Host}}/api/hd"
	"{{.Module}}/internal/router/irouter"
	"github.com/gin-gonic/gin"
)

func Do(sc *ctx.ServerContext, f irouter.HandlerFunc) func(c *gin.Context) {
	return func(c *gin.Context) {
		if err := f(c, sc).Do(); err != nil {
			switch err.(type) {
			case hd.ErrResponse:
				//多语言用
				c.JSON(400, err)
			default:
				c.JSON(400, &hd.ErrResponse{hd.MSG, "", err.Error()})
			}
		}
	}
}
