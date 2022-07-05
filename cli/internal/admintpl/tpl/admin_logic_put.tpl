package logic

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/serctx"
	"errors"

	"github.com/gin-gonic/gin"
	errs "github.com/pkg/errors"
	"gorm.io/gorm"
)

type AdminPut struct {
	ctx    *gin.Context
	serctx *serctx.ServerContext
}

func NewAdminPut(ctx *gin.Context, serCtx *serctx.ServerContext) *AdminPut {
	return &AdminPut{ctx, serCtx}
}

func (this *AdminPut) Put(po *adminmodel.AdminPo2) error {
	db := this.serctx.Db
	tmpPo := &adminmodel.AdminPo2{}
	if r := db.Model(tmpPo).Take(po); r.Error != nil {
		if r.Error == gorm.ErrRecordNotFound {
			return errors.New("记录不存在")
		} else {
			return r.Error
		}
	}
	//其他校验
	if err := this.Valid(po); err != nil {
		return err
	}
	//更新
	if r := db.Select("Phone", "Name", "Status", "Memo", "Email", "IsSuperAdmin", "UpdatedAt").Updates(po); r.Error != nil {
		return r.Error
	}
	return nil
}

func (this *AdminPut) Valid(po *adminmodel.AdminPo2) error {
	var ct = int64(0)
	if r := this.serctx.Db.Model(po).Where("id!=? and phone=?", po.ID, po.Phone).Count(&ct); r.Error != nil {
		return errs.WithMessage(r.Error, "校验失败")
	} else if ct != 0 {
		return errors.New("手机号已存在")
	}

	if r := this.serctx.Db.Model(po).Where("id!=? and email=?", po.ID, po.Email).Count(&ct); r.Error != nil {
		return errs.WithMessage(r.Error, "校验失败")
	} else if ct != 0 {
		return errors.New("Email已存在")
	}
	return nil
}
