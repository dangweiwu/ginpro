package sys

import (
	"{{.Module}}/internal/app/sys/api"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/router"
)

func Route(r *router.Router, sc *ctx.ServerContext) {
	r.Root.GET("/sys", router.Do(sc, api.NewSysQuery))
	r.Root.PUT("/sys", router.Do(sc, api.NewSysAct))
}
