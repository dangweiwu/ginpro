package hd

import "github.com/gin-gonic/gin"

func Bind(ctx *gin.Context, po interface{}) error {
	return ctx.ShouldBindJSON(po)
}
