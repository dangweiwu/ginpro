package metric

import (
	"github.com/gin-gonic/gin"
	"gs/pkg/syncx"
	"sync"

	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
	once    sync.Once
	enabled syncx.AtomicBool
)

// Enabled returns if prometheus is enabled.
func Enabled() bool {
	return enabled.IsTrue()
}

// StartAgent starts a prometheus agent.
func StartAgent(g *gin.Engine, pt, user, pwd string) {

	once.Do(func() {
		enabled.Set(true)
		if len(user) == 0 {
			g.GET(pt, gin.WrapH(promhttp.Handler()))
		} else {
			g.GET(pt, func(context *gin.Context) {
				username := context.GetHeader("username")
				Password := context.GetHeader("password")
				if username == user && Password == pwd {
					context.Next()
				} else {
					context.String(401, "账号秘密错误")
					context.Abort()
				}
			}, gin.WrapH(promhttp.Handler()))
		}

	})
}
