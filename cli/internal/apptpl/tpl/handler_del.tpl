package handler

import (
    "github.com/gin-gonic/gin"
	"{{.Module}}/internal/serctx"
    "{{.Module}}/internal/app/{{.AppPackage}}/logic"
	"gs/api/hd"
)

func Delete(ctx *gin.Context,serCtx *serctx.ServerContext) error {
	var err error
	id, err := hd.GetId(ctx)
	if err != nil {
		return err
	}
	a := logic.New{{.AppName}}Del(ctx, serCtx)
	if err := a.Delete(id); err != nil {
		return err
	} else {
		hd.RepOk(ctx)
		return nil
	}
}