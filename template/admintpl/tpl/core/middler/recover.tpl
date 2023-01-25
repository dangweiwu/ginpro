package middler

import (
	"{{.Module}}/internal/ctx"
	"fmt"
	"github.com/gin-contrib/requestid"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"net"
	"net/http"
	"os"
	"runtime/debug"
	"strings"
)

/*
es mapping kind = panic
*/

func Recovery(sc *ctx.ServerContext) gin.HandlerFunc {
	return func(c *gin.Context) {
		defer func() {
			if err := recover(); err != nil {
				// Check for a broken connection, as it is not really a
				// condition that warrants a panic stack trace.
				var brokenPipe bool
				if ne, ok := err.(*net.OpError); ok {
					if se, ok := ne.Err.(*os.SyscallError); ok {
						if strings.Contains(strings.ToLower(se.Error()), "broken pipe") || strings.Contains(strings.ToLower(se.Error()), "connection reset by peer") {
							brokenPipe = true
						}
					}
				}

				raw := c.Request.URL.RawQuery
				path := c.Request.URL.Path

				if raw != "" {
					path = path + "?" + raw
				}
				//httpRequest, _ := httputil.DumpRequest(c.Request, false)
				if brokenPipe {
					sc.Log.Error("网络中断",
						//zap.Int64("at", time.Now().UnixMilli()),
						//zap.Time("time", time.Now()),
						zap.String("rid", requestid.Get(c)),
						zap.String("path", path),
						zap.Any("error", err),
						zap.String("stack", ""),
						zap.String("kind", "panic"),
					)
					// If the connection is dead, we can't write a status to it.
					c.Error(err.(error)) // nolint: errcheck
					c.Abort()
					return
				}

				sc.Log.Error("系统异常",
					//zap.Int64("at", time.Now().UnixMilli()),
					zap.String("path", path),
					zap.String("rid", requestid.Get(c)),
					//zap.Time("at", time.Now()),
					zap.Any("error", err),
					zap.String("stack", string(debug.Stack())),
					zap.String("kind", "panic"),
				)
				c.AbortWithStatus(http.StatusInternalServerError)
				c.String(500, fmt.Sprintf("%v", err))
			}
		}()
		c.Next()
	}
}