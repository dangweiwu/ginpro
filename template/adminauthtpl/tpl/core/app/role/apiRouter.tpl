package role

import (
	"{{.Module}}/internal/app/role/api"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/router"
)

func Route(r *router.Router, sc *ctx.ServerContext) {

	r.Auth.GET("/role", router.Do(sc, api.NewRoleQuery))

	r.Auth.POST("/role", router.Do(sc, api.NewRoleCreate))

	r.Auth.PUT("/role/:id", router.Do(sc, api.NewRoleUpdate))

	r.Auth.DELETE("/role/:id", router.Do(sc, api.NewRoleDel))

	r.Auth.PUT("/role/auth/:id", router.Do(sc, api.NewSetAuth))

}
