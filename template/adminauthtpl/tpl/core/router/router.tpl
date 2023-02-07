package router

import (
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/middler"
	"github.com/gin-gonic/gin"
)

/**
路由基础定义
*/

type Router struct {
	Root *gin.RouterGroup
	Jwt  *gin.RouterGroup //jwt登陆
	Auth *gin.RouterGroup //权限
}

func NewRouter(g *gin.Engine, sc *ctx.ServerContext) *Router {
	return &Router{
		Root: g.Group("/api"),
		Jwt:  g.Group("/api", middler.TokenPase(sc), middler.LoginCode(sc)),
		Auth: g.Group("/api", middler.TokenPase(sc), middler.LoginCode(sc), middler.CheckAuth(sc)),
	}
}
