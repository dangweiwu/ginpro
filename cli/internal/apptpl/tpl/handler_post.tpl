package handler

import (
	"github.com/gin-gonic/gin"
    "gs/api/hd"
    "{{.Module}}/internal/serctx"
    "{{.Module}}/internal/app/{{.AppPackage}}/logic"
    "{{.Module}}/internal/app/{{.AppPackage}}/{{.ModelPackage}}"
)
func Post(ctx *gin.Context,serCtx *serctx.ServerContext) error {

    //数据源
	po := &{{.ModelPackage}}.{{.ModelName}}{}
	err := hd.Bind(ctx, po)
	if err != nil {
		return err
	}

	a := logic.New{{.AppName}}Post(ctx,serCtx)
	err = a.Post(po)
	if err != nil {
		return err
	}
	hd.RepOk(ctx)
	return nil
}