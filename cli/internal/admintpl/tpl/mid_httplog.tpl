package middler

import (
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/serctx"
	"github.com/gin-contrib/requestid"
	"time"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

// http 日志中间件

/*
es mapping kind=api

	time is iso8601 format
	{
		"level":{"type":"keyword",index:true},
		"time":{"type":"date","index":true},
		"kind":{"type":"keyword","index":true},
		"rid":{"type":"keyword","index":true},
		"msg":{"type":"text"},
		"path":{"type":"text"},
		"latency":{"type":"long"},
		"ip":{"type":"keyword"},
		"method":{"type":"keyword"},
		"status":{"type":"long"},
		"size":{"type":"long"},
		"uid":{"type":"long","index":true},
		"error":{"type":"text"}
	}
*/
var skip = map[string]struct{}{}

func HttpLog(sc *serctx.ServerContext) gin.HandlerFunc {

	return func(c *gin.Context) {
		// Start timer
		start := time.Now()
		path := c.Request.URL.Path
		raw := c.Request.URL.RawQuery

		// Process request
		c.Next()

		// Log only when path is not being skipped
		if _, ok := skip[path]; !ok {
			// Stop timer
			TimeStamp := time.Now()
			Latency := TimeStamp.Sub(start)

			if raw != "" {
				path = path + "?" + raw
			}
			uid, _ := jwtx.GetUid(c)
			sc.Log.Info("请求响应",
				//zap.String("at", TimeStamp.Format("2006-01-02 15:04:05")),
				//zap.Int64("at", time.Now().UnixMilli()),
				zap.Int64("latency", Latency.Milliseconds()),
				zap.String("ip", c.ClientIP()),
				zap.String("method", c.Request.Method),
				zap.Int("status", c.Writer.Status()),
				zap.Int("size", c.Writer.Size()),
				zap.Int64("uid", uid),
				zap.String("error", c.Errors.ByType(gin.ErrorTypePrivate).String()),
				zap.String("kind", "api"),
				zap.String("rid", requestid.Get(c)),
				zap.String("path", path),
			)
		}
	}
}
