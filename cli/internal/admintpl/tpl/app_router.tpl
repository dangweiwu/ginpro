package app

import (
	"{{.Module}}/internal/router"
	"{{.Module}}/internal/serctx"
	"{{.Module}}/internal/app/admin"
)

func RegisterRoute(r *router.Router, sc *serctx.ServerContext) {
	admin.Route(r, sc)
}
