package handler

import (
	"errors"
	"gs/api/hd"

	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/router/irouter"
	"{{.Module}}/internal/serctx"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

/*
获取我的信息
*/
type MyInfo struct {
	*hd.Hd
	ctx *gin.Context
	sc  *serctx.ServerContext
}

func NewMyInfo(ctx *gin.Context, sc *serctx.ServerContext) irouter.IHandler {
	return &MyInfo{hd.NewHd(ctx), ctx, sc}
}

// @tags    系统我的
// @summary 查询信息
// @router  /api/admin/my [get]
// @param   Authorization header   string              true "token"
// @success 200           {object} adminmodel.AdminPo3 "ok"
func (this *MyInfo) Do() error {

	uid, err := jwtx.GetUid(this.ctx)
	if err != nil {
		return err
	}

	po := &adminmodel.AdminPo3{}
	if r := this.sc.Db.Model(po).Where("id = ?", uid).Take(po); r.Error != nil {
		if r.Error == gorm.ErrRecordNotFound {
			return errors.New("记录不存在")
		} else {
			return r.Error
		}
	}
	this.Rep(po)
	return nil
}
