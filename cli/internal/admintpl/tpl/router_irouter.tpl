package irouter

import (
	"{{.Module}}/internal/serctx"
	"github.com/gin-gonic/gin"
)

type (
	IHandler interface {
		Do() error
	}
	HandlerFunc func(ctx *gin.Context, sc *serctx.ServerContext) IHandler
)
