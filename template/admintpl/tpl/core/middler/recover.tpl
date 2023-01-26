package middler

import (
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/pkg/lg"
	"fmt"
	"github.com/gin-contrib/requestid"
	"github.com/gin-gonic/gin"
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
					lg.Msg("网络中断").Kind("api").Uid(requestid.Get(c)).SetErr(err.(error)).Err(sc.Log)
					c.Error(err.(error)) // nolint: errcheck
					c.Abort()
					return
				}

				lg.Msg("系统异常").Kind("api").Uid(requestid.Get(c)).SetErr(err.(error)).ExData(string(debug.Stack())).Err(sc.Log)
				c.AbortWithStatus(http.StatusInternalServerError)
				c.String(500, fmt.Sprintf("%v", err))
			}
		}()
		c.Next()
	}
}
