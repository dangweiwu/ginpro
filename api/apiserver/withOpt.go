package apiserver

import (
	"github.com/gin-gonic/gin"
)

type ApiOpt func(*ApiServer)

//注册全局中间件
func WithMiddle(midf ...gin.HandlerFunc) ApiOpt {
	return func(as *ApiServer) {
		for _, v := range midf {
			as.app.Use(v)
		}
	}
}

//注册静态
func WithStatic(relativePath string, root string) ApiOpt {
	return func(as *ApiServer) {
		as.app.Static(relativePath, root)
	}
}

//注册结束事件
func WithStopEvent(name string, f func() error) ApiOpt {
	return func(as *ApiServer) {
		as.closeEvent[name] = f
	}
}
