package api

import (
	"{{.Module}}/internal/api/demo"
	"{{.Module}}/internal/router"
	"{{.Module}}/internal/ctx"
	"github.com/gin-gonic/gin"
)

var routes = []func(r *router.Router, sc *ctx.ServerContext){
	demo.Route,
}

func RegisterRoute(engine *gin.Engine, sc *ctx.ServerContext) {
	r := router.NewRouter(engine, sc)

	for _, v := range routes {
		v(r, sc)
	}
}
