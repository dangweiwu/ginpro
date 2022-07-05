package handler

/*
token刷新
*/
import (
	"{{.Module}}/internal/app/admin/logic"
	"{{.Module}}/internal/serctx"
	"gs/api/hd"

	"github.com/gin-gonic/gin"
)

func FreshToken(ctx *gin.Context, serCtx *serctx.ServerContext) error {

	//数据源

	a := logic.NewReflashToken(ctx, serCtx)
	data, err := a.ReflashToken()
	if err != nil {
		return err
	}

	hd.Rep(ctx, data)
	return nil
}
