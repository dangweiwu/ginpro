package handler

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/router/irouter"
	"{{.Module}}/internal/serctx"
	"github.com/gin-gonic/gin"
	"gs/api/hd"
)

/*
退出登陆
*/
type LogOut struct {
	*hd.Hd
	ctx *gin.Context
	sc  *serctx.ServerContext
}

func NewLogOut(ctx *gin.Context, sc *serctx.ServerContext) irouter.IHandler {
	return &LogOut{hd.NewHd(ctx), ctx, sc}
}

func (this *LogOut) Do() error {
	this.Logout()
	this.Hd.RepOk()
	return nil
}

func (this *LogOut) Logout() error {
	//获取id
	id, err := jwtx.GetUid(this.ctx)
	if err != nil {
		return nil
	}
	//删除logincode
	this.sc.Redis.Del(adminmodel.GetAdminRedisLoginId(int(id)))

	//删除刷新token
	this.sc.Redis.Del(adminmodel.GetAdminRedisRefreshTokenId(int(id)))
	return nil
}
