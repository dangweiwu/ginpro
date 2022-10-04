package admin

import (
	"{{.Module}}/internal/app/admin/handler"
	"{{.Module}}/internal/router"
	"{{.Module}}/internal/serctx"
)

func Route(r *router.Router, sc *serctx.ServerContext) {
	if sc.Config.Admin.InitAdmin {
		r.Root.GET("/initadmin", router.Do(sc, handler.NewInitAdmin))
	}

	r.Jwt.GET("/admin", router.Do(sc, handler.NewAdminGet))

	r.Jwt.POST("/admin", router.Do(sc, handler.NewAdminPost))

	r.Jwt.PUT("/admin/:id", router.Do(sc, handler.NewAdminPut))

	r.Jwt.DELETE("/admin/:id", router.Do(sc, handler.NewAdminDel))

	r.Root.POST("/admin/login", router.Do(sc, handler.NewAdminLogin))

	r.Jwt.POST("/token/reflesh", router.Do(sc, handler.NewReflashToken))

	r.Jwt.PUT("/admin/resetpwd/:id", router.Do(sc, handler.NewResetPassword))

	r.Jwt.GET("/admin/my", router.Do(sc, handler.NewMyInfo))

	r.Jwt.PUT("/admin/my", router.Do(sc, handler.NewMyPut))

	r.Jwt.PUT("/admin/my/password", router.Do(sc, handler.NewMySetPwd))
}
