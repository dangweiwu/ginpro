package app

import (
	"{{.Module}}/internal/router"
	"{{.Module}}/internal/serctx"
)

func RegisterRoute(r *router.Router, sc *serctx.ServerContext) {
	//demo.Route(r, sc)
}
