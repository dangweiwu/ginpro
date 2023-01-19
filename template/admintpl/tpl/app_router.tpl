package app

import (
	"{{.Module}}/internal/app/admin"
	"{{.Module}}/internal/router"
	"{{.Module}}/internal/serctx"
	"github.com/gin-gonic/gin"
)

var routes = []func(r *router.Router, sc *serctx.ServerContext){
	admin.Route,
}

func RegisterRoute(engine *gin.Engine, sc *serctx.ServerContext) {
	r := router.NewRouter(engine, sc)
	//regroute
	for _, v := range routes {
		v(r, sc)
	}
}
