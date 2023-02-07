package admin

import (
	"{{.Module}}/internal/app/admin/api"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/router"
)

func Route(r *router.Router, sc *ctx.ServerContext) {

	r.Auth.GET("/admin", router.Do(sc, api.NewAdminQuery))

	r.Auth.POST("/admin", router.Do(sc, api.NewAdminCreate))

	r.Auth.PUT("/admin/:id", router.Do(sc, api.NewAdminUpdate))

	r.Auth.DELETE("/admin/:id", router.Do(sc, api.NewAdminDel))

	r.Auth.PUT("/admin/resetpwd/:id", router.Do(sc, api.NewResetPassword))

}
