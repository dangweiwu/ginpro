package admin

import (
	"{{.Module}}/internal/app/admin/handler"
	"{{.Module}}/internal/router"
	"{{.Module}}/internal/serctx"
)

func Route(r *router.Router, serCtx *serctx.ServerContext) {

	r.Jwt.GET("/admin", router.Do(serCtx, handler.Get))

	r.Jwt.POST("/admin", router.Do(serCtx, handler.Post))

	r.Jwt.PUT("/admin/:id", router.Do(serCtx, handler.Put))

	r.Jwt.DELETE("/admin/:id", router.Do(serCtx, handler.Delete))

	r.Root.POST("/admin/login", router.Do(serCtx, handler.Login))

	r.Jwt.POST("/token/reflesh", router.Do(serCtx, handler.FreshToken))
}
