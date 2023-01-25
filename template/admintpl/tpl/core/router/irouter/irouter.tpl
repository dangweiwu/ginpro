package irouter

import (
	"{{.Module}}/internal/ctx"
	"github.com/gin-gonic/gin"
)

type (
	IHandler interface {
		Do() error
	}
	HandlerFunc func(c *gin.Context, sc *ctx.ServerContext) IHandler
)
