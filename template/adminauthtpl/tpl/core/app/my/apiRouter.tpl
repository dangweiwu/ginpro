package my

import (
	"{{.Module}}/internal/app/my/api"
	"{{.Module}}/internal/router"
	"{{.Module}}/internal/ctx"
)

func Route(r *router.Router, sc *ctx.ServerContext) {

	r.Jwt.GET("/my", router.Do(sc, api.NewMyInfo))

	r.Jwt.PUT("/my", router.Do(sc, api.NewMyUpdate))

	r.Jwt.PUT("/my/password", router.Do(sc, api.NewMyUpdatePwd))

	r.Root.POST("/login", router.Do(sc, api.NewLogin))

	r.Jwt.POST("/logout", router.Do(sc, api.NewLogOut))

	r.Jwt.POST("/token/refresh", router.Do(sc, api.NewRefreshToken))

	r.Jwt.GET("/my-auth", router.Do(sc, api.NewMyAuth))
}
