package router

import (
	"{{.Module}}/internal/serctx"
	"fmt"
	"gs/api/hd"

	"{{.Module}}/internal/router/irouter"

	"github.com/gin-gonic/gin"
)

func Do(sc *serctx.ServerContext, f irouter.HandlerFunc) func(ctx *gin.Context) {
	return func(ctx *gin.Context) {
		//添加log id
		defer func() {
			err := recover()
			if err != nil {
				ctx.JSON(500, &hd.ErrResponse{hd.MSG, fmt.Sprintf("%v", err), "panic"})
			}
		}()
		if err := f(ctx, sc).Do(); err != nil {
			switch err.(type) {
			case hd.ErrResponse:
				//多语言用
				ctx.JSON(400, err)
			default:
				ctx.JSON(400, &hd.ErrResponse{hd.MSG, err.Error(), ""})
			}
		}
	}
}
