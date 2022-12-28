package apiserver

import (
	"github.com/gin-gonic/gin"
)

type ApiOpt func(engine *gin.Engine)

// 注册全局中间件
func WithMiddle(midf ...gin.HandlerFunc) ApiOpt {
	return func(as *gin.Engine) {
		for _, v := range midf {
			as.Use(v)
		}
	}
}

// 注册静态
func WithStatic(relativePath string, root string) ApiOpt {
	return func(as *gin.Engine) {
		as.Static(relativePath, root)
		as.GET("/", func(c *gin.Context) {
			//重定向到主页面
			c.Request.URL.Path = relativePath
			as.HandleContext(c)
		})
	}
}

// 注册中间件
func RegMiddler(engine *gin.Engine, opt ...ApiOpt) {
	for _, v := range opt {
		v(engine)
	}
}
