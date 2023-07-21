package middler

import (
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/pkg/jwtx"
	"github.com/gin-gonic/gin"
	"{{.Host}}/api/hd"
	"fmt"
)

func NoAuthErrResponse(c *gin.Context, data string) {
	c.JSON(403, hd.ErrMsg(data, "缺少权限"))
	c.Abort()
}

// 权限中间件
func CheckAuth(sc *ctx.ServerContext) gin.HandlerFunc {
	return func(context *gin.Context) {
		yes, err := jwtx.GetIsSuper(context)
		if err != nil {
			NoAuthErrResponse(context, err.Error())
			return
		}
		if yes {
			context.Next()
			return
		}
		role, err := jwtx.GetRole(context)
		if err != nil {
			NoAuthErrResponse(context, err.Error())
			return
		}

		if ok, err := sc.AuthCheck.Check(role, context.FullPath(), context.Request.Method); ok {
			context.Next()
			return
		} else if err != nil {
			NoAuthErrResponse(context, err.Error())
		} else {
		    NoAuthErrResponse(context, fmt.Sprintf("%s:%s", context.Request.Method, context.FullPath()))
		}
	}
}
