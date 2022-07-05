package handler

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/admin/logic"
	"{{.Module}}/internal/serctx"
	"gs/api/hd"

	"github.com/gin-gonic/gin"
)

func Login(ctx *gin.Context, serCtx *serctx.ServerContext) error {

	//数据源
	po := &adminmodel.LoginForm{}
	err := hd.Bind(ctx, po)
	if err != nil {
		return err
	}

	a := logic.NewAdminLogin(ctx, serCtx)
	data, err := a.Login(po)
	if err != nil {
		return err
	}
	hd.Rep(ctx, data)
	return nil
}
