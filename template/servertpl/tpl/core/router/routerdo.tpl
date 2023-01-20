package router

import (
	"{{.Module}}/internal/ctx"
	"{{.Host}}/api/hd"
	"{{.Module}}/internal/router/irouter"
	"github.com/gin-gonic/gin"
)

func Do(sc *ctx.ServerContext, f irouter.HandlerFunc) func(ctx *gin.Context) {
	return func(ctx *gin.Context) {
		if err := f(ctx, sc).Do(); err != nil {
			switch err.(type) {
			case hd.ErrResponse:
				//多语言用
				ctx.JSON(400, err)
			default:
				ctx.JSON(400, &hd.ErrResponse{hd.MSG, "", err.Error()})
			}
		}
	}
}
