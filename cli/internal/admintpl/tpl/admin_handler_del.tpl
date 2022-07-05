package handler

import (
	"{{.Module}}/internal/app/admin/logic"
	"{{.Module}}/internal/serctx"
	"gs/api/hd"

	"github.com/gin-gonic/gin"
)

func Delete(ctx *gin.Context, serCtx *serctx.ServerContext) error {
	var err error
	id, err := hd.GetId(ctx)
	if err != nil {
		return err
	}
	a := logic.NewAdminDel(ctx, serCtx)
	if err := a.Delete(id); err != nil {
		return err
	} else {
		hd.RepOk(ctx)
		return nil
	}
}
