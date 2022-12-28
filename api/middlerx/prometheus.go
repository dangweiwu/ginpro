package middlerx

import (
	"github.com/gin-gonic/gin"
	"gs/pkg/metric"
	"strconv"
	"time"
)

//统计错误和请求数

const serverNamespace = "http_server"

var (
	metricServerReqDur = metric.NewHistogramVec(&metric.HistogramVecOpts{
		Namespace: serverNamespace,
		Subsystem: "requests",
		Name:      "duration_ms",
		Help:      "http server requests duration(ms).",
		Labels:    []string{"path"},
		Buckets:   []float64{5, 10, 25, 50, 100, 250, 500, 1000},
	})
	//sum(rate(http_server_requests_duration_ms_count{app="http"}[3m])) by (path)
	//”http_server_requests_duration_ms“ bucket count sum
	metricServerReqCodeTotal = metric.NewCounterVec(&metric.CounterVecOpts{
		Namespace: serverNamespace,
		Subsystem: "requests",
		Name:      "code_total",
		Help:      "http server requests error count.",
		Labels:    []string{"path", "code"},
	})
	//sum(rate(http_server_requests_code_total{app="http"}[5m])) by (code)
)

func PrometheusMiddler(skipPath map[string]struct{}) gin.HandlerFunc {
	return func(context *gin.Context) {
		path := context.Request.URL.Path
		if _, has := skipPath[path]; has {
			context.Next()
		} else {
			startTime := time.Now()
			context.Next()
			//与定义的labels一致
			metricServerReqDur.Observe(time.Now().UnixMilli()-startTime.UnixMilli(), path)
			metricServerReqCodeTotal.Inc(path, strconv.Itoa(context.Writer.Status()))
		}
	}
}
