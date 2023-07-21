package api

import (
	"{{.Module}}/internal/ctx"
	"github.com/gin-gonic/gin"
)

// 密码校验
func AuthSysPassword(c *gin.Context, sc *ctx.ServerContext) bool {
	k := c.GetHeader("Authorization")
	if len(k) == 0 {
		return false
	}
	if sc.Config.App.Password != k {
		c.JSON(401, "缺少鉴权")
		c.Abort()
		return false
	}
	return true
}
