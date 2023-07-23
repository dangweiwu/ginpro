package middler

import (
	"{{.Module}}/internal/ctx"
	"github.com/gin-gonic/gin"
	"github.com/gin-contrib/requestid"
)

//批量注册全局中间件
func RegMiddler(sc *ctx.ServerContext) []gin.HandlerFunc {
	return []gin.HandlerFunc{
		requestid.New(),
        Recovery(sc),
        sc.Tracer.GinMiddler(),
        HttpLog(sc),
        Cors(),
        PromMiddler(sc),
	}
}
