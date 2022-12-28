package middler

import (
	"{{.Module}}/internal/serctx"
	"github.com/gin-gonic/gin"
	"github.com/gin-contrib/requestid"
	"gs/api/middlerx"
)

//批量注册全局中间件
func RegMiddler(sc *serctx.ServerContext) []gin.HandlerFunc {
	return []gin.HandlerFunc{
		requestid.New(),
        Recovery(sc),
        HttpLog(sc),
        Cors(),
        middlerx.PrometheusMiddler(map[string]struct{}{}),

	}
}
