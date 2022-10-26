package handler

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/pkg"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/router/irouter"
	"{{.Module}}/internal/serctx"
	"errors"
	"gs/api/hd"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

/*
重置账号密码
*/

type ResetPassword struct {
	*hd.Hd
	ctx *gin.Context
	sc  *serctx.ServerContext
}

func NewResetPassword(ctx *gin.Context, sc *serctx.ServerContext) irouter.IHandler {
	return &ResetPassword{hd.NewHd(ctx), ctx, sc}
}
func (this *ResetPassword) Do() error {
	var err error
	id, err := this.GetId()
	if err != nil {
		return err
	}
	po := &adminmodel.AdminPo{}
	po.ID = id
	err = this.ResetPassword(po)
	if err != nil {
		return err
	}
	this.RepOk()
	return nil
}

func (this *ResetPassword) ResetPassword(rawPo *adminmodel.AdminPo) error {

	id, err := jwtx.GetUid(this.ctx)
	if err != nil {
		return err
	}
	if id == rawPo.ID {
		return errors.New("不能重置自己密码")
	}

	po := &adminmodel.AdminPo{}
	if r := this.sc.Db.Model(po).Where("id=?", rawPo.ID).Take(po); r.Error != nil {
		if r.Error == gorm.ErrRecordNotFound {
			return errors.New("记录不存在")
		} else {
			return r.Error
		}
	}

	pwd := pkg.GetPassword(this.sc.Config.Admin.RawPassword)
	r := this.sc.Db.Model(po).Update("password", pwd)

	//踢出在线
	this.sc.Redis.Del(adminmodel.GetAdminRedisLoginId(int(po.ID)))

	//删除刷新token
	this.sc.Redis.Del(adminmodel.GetAdminRedisRefreshTokenId(int(po.ID)))
	return r.Error
}
