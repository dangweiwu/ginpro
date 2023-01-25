package api

import (
	"{{.Module}}/internal/app/my/mymodel"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/router/irouter"
	"{{.Module}}/internal/ctx"
	"github.com/gin-gonic/gin"
	"{{.Host}}/api/hd"
	"context"
)

/*
退出登陆
*/
type LogOut struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewLogOut(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &LogOut{hd.NewHd(c), c, sc}
}

// @tags    系统我的
// @summary 退  出
// @router  /api/logout [post]
// @param   Authorization header   string                   true "token"
// @success 200           {object} hd.Response{data=string} "ok"
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
	this.sc.Redis.Del(context.Background(), mymodel.GetAdminRedisLoginId(this.sc.Config.App.Name, int(id)))

	//删除刷新token
	this.sc.Redis.Del(context.Background(), mymodel.GetAdminRedisRefreshTokenId(this.sc.Config.App.Name, int(id)))
	return nil
}