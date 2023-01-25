package admin

import (
	"{{.Module}}/internal/app/admin/api"
	"{{.Module}}/internal/router"
	"{{.Module}}/internal/ctx"
)

func Route(r *router.Router, sc *ctx.ServerContext) {

	r.Jwt.GET("/admin", router.Do(sc, api.NewAdminQuery))

	r.Jwt.POST("/admin", router.Do(sc, api.NewAdminCreate))

	r.Jwt.PUT("/admin/:id", router.Do(sc, api.NewAdminUpdate))

	r.Jwt.DELETE("/admin/:id", router.Do(sc, api.NewAdminDel))

    r.Jwt.PUT("/admin/resetpwd/:id", router.Do(sc, api.NewResetPassword))

}
