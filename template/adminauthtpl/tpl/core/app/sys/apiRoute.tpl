package sys

import (
	"{{.Module}}/internal/app/sys/api"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/router"
	"github.com/gin-gonic/gin"
)

func Route(r *router.Router, sc *ctx.ServerContext) {
	r.Root.GET("/sys", gin.BasicAuth(gin.Accounts{sc.Config.App.Name: sc.Config.App.Password}), router.Do(sc, api.NewSysQuery))
	r.Root.PUT("/sys", gin.BasicAuth(gin.Accounts{sc.Config.App.Name: sc.Config.App.Password}), router.Do(sc, api.NewSysAct))
}
