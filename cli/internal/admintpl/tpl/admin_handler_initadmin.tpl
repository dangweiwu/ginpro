package handler

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/pkg"
	"{{.Module}}/internal/router/irouter"
	"{{.Module}}/internal/serctx"
	"errors"
	"gs/api/hd"

	"github.com/gin-gonic/gin"
	errs "github.com/pkg/errors"
)

type InitAdmin struct {
	*hd.Hd
	ctx *gin.Context
	sc  *serctx.ServerContext
}

func NewInitAdmin(ctx *gin.Context, sc *serctx.ServerContext) irouter.IHandler {
	return &InitAdmin{hd.NewHd(ctx),ctx, sc}
}

func (this *InitAdmin) Do() error {

	//数据源
	po := &adminmodel.AdminPo{}
	po.Name = "超级管理员"
	po.Account = "admin"
	po.Password = this.sc.Config.Admin.RawPassword
	po.IsSuperAdmin = "1"
	err := this.Create(po)
	if err != nil {
		return err
	}
	this.RepOk()
	return nil
}

func (this *InitAdmin) Create(po *adminmodel.AdminPo) error {
	db := this.sc.Db
	//验证是否已创建 或者其他检查
	if err := this.Valid(po); err != nil {
		return err
	}

	po.Password = pkg.GetPassword(po.Password)

	if r := db.Create(po); r.Error != nil {
		return r.Error
	}
	return nil
}

func (this *InitAdmin) Valid(po *adminmodel.AdminPo) error {
	db := this.sc.Db
	var ct = int64(0)
	if r := db.Model(po).Where("account = ?", po.Account).Count(&ct); r.Error != nil {
		return errs.WithMessage(r.Error, "校验失败")
	} else if ct != 0 {
		return errors.New("账号已存在")
	}

	if po.Phone != "" {
		if r := db.Model(po).Where("account = ?", po.Phone).Count(&ct); r.Error != nil {
			return errs.WithMessage(r.Error, "校验失败")
		} else if ct != 0 {
			return errors.New("手机号已存在")
		}
	}

	if po.Email != "" {
		if r := db.Model(po).Where("Email = ?", po.Email).Count(&ct); r.Error != nil {
			return errs.WithMessage(r.Error, "校验失败")
		} else if ct != 0 {
			return errors.New("Email已存在")
		}
	}
	return nil

}
