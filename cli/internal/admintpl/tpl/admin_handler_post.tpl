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

type AdminPost struct {
	ctx    *gin.Context
	serctx *serctx.ServerContext
}

func NewAdminPost(ctx *gin.Context, serCtx *serctx.ServerContext) irouter.IHandler {
	return &AdminPost{ctx, serCtx}
}

func (this *AdminPost) Do() error {

	//数据源
	po := &adminmodel.AdminPo{}
	err := hd.Bind(this.ctx, po)
	if err != nil {
		return err
	}
	err = this.Post(po)
	if err != nil {
		return err
	}
	hd.RepOk(this.ctx)
	return nil
}

func (this *AdminPost) Post(po *adminmodel.AdminPo) error {
	db := this.serctx.Db
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

func (this *AdminPost) Valid(po *adminmodel.AdminPo) error {
	db := this.serctx.Db
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
