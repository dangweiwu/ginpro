package handler

import (
	"github.com/gin-gonic/gin"
	"{{.Module}}/internal/serctx"
    "{{.Module}}/internal/app/admin/logic"
	"gs/api/hd"
)

func Get(ctx *gin.Context,serCtx *serctx.ServerContext) error {
	a := logic.NewAdminGet(ctx,serCtx)
	data,err := a.Query()
	if err != nil {
		return err
	} else {
		hd.Rep(ctx, data)
		return nil
	}
}