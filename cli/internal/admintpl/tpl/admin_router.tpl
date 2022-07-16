package admin

import (
	"{{.Module}}/internal/app/admin/handler"
	"{{.Module}}/internal/router"
	"{{.Module}}/internal/serctx"
)

func Route(r *router.Router, serCtx *serctx.ServerContext) {
	if serCtx.Config.Admin.InitAdmin {
		r.Root.GET("/initadmin", router.Do(serCtx, handler.NewInitAdmin))
	}

	r.Jwt.GET("/admin", router.Do(serCtx, handler.NewAdminGet))

	r.Jwt.POST("/admin", router.Do(serCtx, handler.NewAdminPost))

	r.Jwt.PUT("/admin/:id", router.Do(serCtx, handler.NewAdminPut))

	r.Jwt.DELETE("/admin/:id", router.Do(serCtx, handler.NewAdminDel))

	r.Root.POST("/admin/login", router.Do(serCtx, handler.NewAdminLogin))

	r.Jwt.POST("/token/reflesh", router.Do(serCtx, handler.NewReflashToken))

	r.Jwt.PUT("/admin/resetpwd/:id", router.Do(serCtx, handler.NewResetPassword))

	r.Jwt.GET("/admin/my", router.Do(serCtx, handler.NewMyInfo))

	r.Jwt.PUT("/admin/my", router.Do(serCtx, handler.NewMyPut))

	r.Jwt.PUT("/admin/my/password", router.Do(serCtx, handler.NewMySetPwd))
}
