package app

import (
	"{{.Module}}/internal/app/admin"
    "{{.Module}}/internal/app/my"
	"{{.Module}}/internal/router"
	"{{.Module}}/internal/ctx"
	"github.com/gin-gonic/gin"
	"{{.Module}}/internal/app/sys"
)

var routes = []func(r *router.Router, sc *ctx.ServerContext){
	admin.Route,
	my.Route,
	sys.Route,
}

func RegisterRoute(engine *gin.Engine, sc *ctx.ServerContext) {
	r := router.NewRouter(engine, sc)
	//regroute
	for _, v := range routes {
		v(r, sc)
	}
}
