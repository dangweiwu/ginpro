package api

import (
	"{{.Module}}/internal/app/sys/sysmodel"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/router/irouter"
	"errors"
	"github.com/gin-gonic/gin"
	"{{.Host}}/api/hd"
)

type SysAct struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewSysAct(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &SysAct{hd.NewHd(c), c, sc}
}

// @x-group		{"key":"Sys","inorder":2}
// @summary	    修改系统变量
// @router		/api/sys [put]
// @param   Authorization header   string                   true " " extensions(x-name=鉴权,x-value=password)
// @param		root			body		sysmodel.SysActForm	true	" "
// @success	200				{string}	string	"{data:'ok'}"
func (this *SysAct) Do() error {
	if !AuthSysPassword(this.ctx, this.sc) {
		return nil
	}
	form := &sysmodel.SysActForm{}
	err := this.Bind(form)
	if err != nil {
		return err
	}

	name := form.Name
	if name == "" {
		return errors.New("缺少名称")
	}

	switch name {
	case "trace":
		if this.sc.Config.Trace.Enable {
			if form.Act == "0" {
				this.sc.OpenTrace.Set(false)
			} else if form.Act == "1" {
				this.sc.OpenTrace.Set(true)
			} else {
				return errors.New("未知指令")
			}
		} else {
			return errors.New("trace 未启动")
		}
	case "metric":
		if this.sc.Config.Prom.Enable {
			if form.Act == "0" {
				this.sc.OpenMetric.Set(false)
			} else if form.Act == "1" {
				this.sc.OpenMetric.Set(true)
			} else {
				return errors.New("未知指令")
			}
		} else {
			return errors.New("metric 未启动")
		}
	default:
		return errors.New("无效名称")
	}
	this.RepOk()
	return nil
}
