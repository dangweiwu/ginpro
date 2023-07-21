package middler

import (
	"{{.Module}}/internal/ctx"
	"github.com/gin-gonic/gin"
	"go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin"
)

/*
链路追踪中间件
*/
func Trace(sc *ctx.ServerContext) gin.HandlerFunc {
	return func(context *gin.Context) {
		if sc.OpenTrace.IsTrue() {
			f := otelgin.Middleware(sc.Config.App.Name)
			f(context)
		} else {
			context.Next()
		}
	}
}
