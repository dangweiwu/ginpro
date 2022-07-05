package handler

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/admin/logic"
	"{{.Module}}/internal/serctx"
	"gs/api/hd"

	"github.com/gin-gonic/gin"
)

func Post(ctx *gin.Context, serCtx *serctx.ServerContext) error {

	//数据源
	po := &adminmodel.AdminPo{}
	err := hd.Bind(ctx, po)
	if err != nil {
		return err
	}

	a := logic.NewAdminPost(ctx, serCtx)
	err = a.Post(po)
	if err != nil {
		return err
	}
	hd.RepOk(ctx)
	return nil
}
