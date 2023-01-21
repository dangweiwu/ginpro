package demo

import (
	"{{.Module}}/internal/app/demo/api"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/router"
)

func Route(r *router.Router, sc *ctx.ServerContext) {

	r.Root.GET("/demo", router.Do(sc, api.NewDemoInfo))
}
