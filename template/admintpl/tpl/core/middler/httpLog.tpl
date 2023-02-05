package middler

import (
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/pkg/lg"
	"github.com/gin-contrib/requestid"
	"time"
	"github.com/gin-gonic/gin"
)

// http 日志中间件

/*
es mapping kind=api

	time is iso8601 format
	{
		"level":{"type":"keyword"},
		"time":{"type":"date"},
		"kind":{"type":"keyword"},
		"rid":{"type":"keyword"},
		"msg":{"type":"text"},
		"path":{"type":"text"},
		"latency":{"type":"long",index:false},
		"ip":{"type":"keyword"},
		"method":{"type":"keyword"},
		"status":{"type":"long"},
		"size":{"type":"long"},
		"uid":{"type":"long"},
		"error":{"type":"keyword",index:false},
		"stack":{"type":"keyword",index:false}
	}
*/
var skipPath = map[string]struct{}{}
var skipMethod = map[string]struct{}{
	"GET": {},
}

func HttpLog(sc *ctx.ServerContext) gin.HandlerFunc {

	return func(c *gin.Context) {
		// Start timer
		start := time.Now()
		path := c.Request.URL.Path
		raw := c.Request.URL.RawQuery

		// Process request
		c.Next()

		// Log only when path is not being skipped
		_, ok := skipPath[c.FullPath()]
		_, ok2 := skipMethod[c.Request.Method]
		if !ok && !ok2 {
			// Stop timer
			TimeStamp := time.Now()
			Latency := TimeStamp.Sub(start)

			if raw != "" {
				path = path + "?" + raw
			}
			uid, _ := jwtx.GetUid(c)
			log := lg.Msg("request").
				Kind("api").
				Uid(requestid.Get(c)).
				Id(uid).
				Api(c.Request.Method, path, c.Writer.Status(), c.Writer.Size(), int(Latency.Milliseconds()))

			errmsg := c.Errors.String()
			if len(errmsg) != 0 {
				log.ExData(errmsg).Err(sc.Log)
			}
			log.Info(sc.Log)
		}
	}
}
