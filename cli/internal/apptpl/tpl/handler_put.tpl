package handler

import (
	"github.com/gin-gonic/gin"
    "gs/api/hd"
    "{{.Module}}/internal/serctx"
    "{{.Module}}/internal/app/{{.AppPackage}}/logic"
    "{{.Module}}/internal/app/{{.AppPackage}}/{{.ModelPackage}}"
)

func Put(ctx *gin.Context,serCtx *serctx.ServerContext) error {
	var err error
	id, err := hd.GetId(ctx)
	if err != nil {
		return err
	}
	po := &{{.ModelPackage}}.{{.ModelName}}{}
	err = hd.Bind(ctx, po)
	if err != nil {
		return err
	}
	po.ID = id
	a := logic.New{{.AppName}}Put(ctx,serCtx)
	err = a.Put(po)
	if err != nil {
		return err
	}
	hd.RepOk(ctx)
	return nil
}
