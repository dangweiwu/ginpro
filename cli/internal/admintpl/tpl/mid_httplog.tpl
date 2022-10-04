package middler

import (
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/serctx"
	"time"

	"github.com/gin-contrib/requestid"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

//http 日志中间件
func HttpLog(sc *serctx.ServerContext) gin.HandlerFunc {
	return func(c *gin.Context) {
		start := time.Now()
		// clientId := c.ClientIP()
		// some evil middlewares modify this values
		path := c.Request.URL.Path
		query := c.Request.URL.RawQuery
		// c.Set(config.CLINET_ID, clientId)
		c.Next()

		end := time.Now()
		latency := end.Sub(start)
		end = end.UTC()

		if len(c.Errors) > 0 {
			// Append error field if this is an erroneous request.
			for _, e := range c.Errors.Errors() {
				sc.Log.Error(e)
			}
		} else {
			
			uid,_:=jwtx.GetUid(c)
			sc.Log.Info(
				path,
				zap.String("id", requestid.Get(c)),
				zap.Int64("uid", uid),
				zap.Int("status", c.Writer.Status()),
				zap.String("method", c.Request.Method),
				zap.String("path", path),
				zap.String("query", query),
				zap.String("ip", c.ClientIP()),
				zap.String("user-agent", c.Request.UserAgent()),
				zap.String("time", end.Format(time.RFC3339)),
				zap.Duration("latency", latency),
				// zap.String("body", c.Writer.WriteString()),
			)
		}
	}
}