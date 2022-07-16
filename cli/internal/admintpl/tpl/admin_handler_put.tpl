package handler

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/router/irouter"
	"{{.Module}}/internal/serctx"
	"errors"
	"gs/api/hd"

	"github.com/gin-gonic/gin"
	errs "github.com/pkg/errors"
	"gorm.io/gorm"
)

type AdminPut struct {
	ctx    *gin.Context
	serctx *serctx.ServerContext
}

func NewAdminPut(ctx *gin.Context, serCtx *serctx.ServerContext) irouter.IHandler {
	return &AdminPut{ctx, serCtx}
}
func (this *AdminPut) Do() error {
	var err error
	id, err := hd.GetId(this.ctx)
	if err != nil {
		return err
	}
	po := &adminmodel.AdminPo2{}
	err = hd.Bind(this.ctx, po)
	if err != nil {
		return err
	}
	po.ID = id
	err = this.Put(po)
	if err != nil {
		return err
	}
	hd.RepOk(this.ctx)
	return nil
}
func (this *AdminPut) Put(po *adminmodel.AdminPo2) error {
	db := this.serctx.Db
	tmpPo := &adminmodel.AdminPo2{}
	tmpPo.ID = po.ID
	if r := db.Model(tmpPo).Take(tmpPo); r.Error != nil {
		if r.Error == gorm.ErrRecordNotFound {
			return errors.New("记录不存在")
		} else {
			return r.Error
		}
	}
	uid, err := jwtx.GetUid(this.ctx)
	if err != nil {
		return err
	}

	if tmpPo.ID == uid {
		if tmpPo.Status == "1" && po.Status == "0" {
			return errors.New("不能禁用自己")
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
	//踢掉禁用人员
	if tmpPo.Status == "1" && po.Status == "0" {
		this.serctx.Redis.Del(adminmodel.GetAdminId(int(uid)))
	}

	return nil
}

func (this *AdminPut) Valid(po *adminmodel.AdminPo2) error {
	var ct = int64(0)
	if po.Phone != "" {
		if r := this.serctx.Db.Model(po).Where("account = ?", po.Phone).Count(&ct); r.Error != nil {
			return errs.WithMessage(r.Error, "校验失败")
		} else if ct != 0 {
			return errors.New("手机号已存在")
		}
	}

	if po.Email != "" {
		if r := this.serctx.Db.Model(po).Where("Email = ?", po.Email).Count(&ct); r.Error != nil {
			return errs.WithMessage(r.Error, "校验失败")
		} else if ct != 0 {
			return errors.New("Email已存在")
		}
	}

	return nil
}
