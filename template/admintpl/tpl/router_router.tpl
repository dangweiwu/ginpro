package router

import (
	"{{.Module}}/internal/middler"
	"{{.Module}}/internal/serctx"

	"github.com/gin-gonic/gin"
)

/**
路由基础定义
*/

type Router struct {
	Root *gin.RouterGroup
	Jwt  *gin.RouterGroup //jwt登陆
}

func NewRouter(g *gin.Engine, sc *serctx.ServerContext) *Router {
	return &Router{
		Root: g.Group("/"),
		Jwt:  g.Group("/api", middler.TokenPase(sc), middler.LoginCode(sc)),
	}
}
