package api

import (
	"{{.Module}}/internal/app/sys/sysmodel"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/router/irouter"
	"github.com/gin-gonic/gin"
	"{{.Host}}/api/hd"
	"time"
	"{{.Host}}/pkg/metric"
)

type SysQuery struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewSysQuery(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &SysQuery{hd.NewHd(c), c, sc}
}

// @x-group		{"key":"sys","inorder":1}
// @summary	查询Sys
// @router		/api/sys [get]
// @param   Authorization header   string                   true " " extensions(x-name=鉴权,x-value=password)
// @success	200		{object}	sysmodel.SysVo	" "
func (this *SysQuery) Do() error {
	vo := &sysmodel.SysVo{}
	vo.StartTime = this.sc.StartTime.String()
	vo.RunTime = time.Now().Sub(this.sc.StartTime).String()
	if this.sc.OpenTrace.IsTrue() {
		vo.OpenTrace = "1"
	} else {
		vo.OpenTrace = "0"
	}

	if metric.Enabled() {
		vo.OpenMetric = "1"
	} else {
		vo.OpenMetric = "0"
	}

	this.Rep(vo)
	return nil
}
