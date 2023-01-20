package demo

import (
	"{{.Module}}/internal/api/demo/handler"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/router"
)

func Route(r *router.Router, sc *ctx.ServerContext) {

	r.Root.GET("/demo", router.Do(sc, handler.NewDemoInfo))
}
