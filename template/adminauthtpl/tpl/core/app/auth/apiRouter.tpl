package auth

import (
	"{{.Module}}/internal/app/auth/api"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/router"
)

func Route(r *router.Router, sc *ctx.ServerContext) {

	r.Auth.GET("/auth", router.Do(sc, api.NewAuthQuery))

	r.Auth.POST("/auth", router.Do(sc, api.NewAuthCreate))

	r.Auth.PUT("/auth/:id", router.Do(sc, api.NewAuthUpdate))

	r.Auth.DELETE("/auth/:id", router.Do(sc, api.NewAuthDel))

	r.Root.GET("/allurl", router.Do(sc, api.NewGetFullUrl))
}
