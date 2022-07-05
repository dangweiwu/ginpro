package handler

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/admin/logic"
	"{{.Module}}/internal/serctx"
	"gs/api/hd"

	"github.com/gin-gonic/gin"
)

func Put(ctx *gin.Context, serCtx *serctx.ServerContext) error {
	var err error
	id, err := hd.GetId(ctx)
	if err != nil {
		return err
	}
	po := &adminmodel.AdminPo2{}
	err = hd.Bind(ctx, po)
	if err != nil {
		return err
	}
	po.ID = id
	a := logic.NewAdminPut(ctx, serCtx)
	err = a.Put(po)
	if err != nil {
		return err
	}
	hd.RepOk(ctx)
	return nil
}
