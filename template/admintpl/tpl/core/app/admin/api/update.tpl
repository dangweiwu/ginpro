package api

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/my/mymodel"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/router/irouter"
	"{{.Module}}/internal/ctx"
	"errors"
	"{{.Host}}/api/hd"
    "context"
	"github.com/gin-gonic/gin"
	errs "github.com/pkg/errors"
	"gorm.io/gorm"
)

type AdminUpdate struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewAdminUpdate(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &AdminUpdate{hd.NewHd(c), c, sc}
}

// @tags    系统用户
// @summary 修改用户
// @router  /api/admin/:id [put]
// @param   id            path     int                      true "用户ID"
// @param   Authorization header   string                   true "token"
// @param   root          body     adminmodel.AdminPo2      true "修改信息"
// @success 200           {object} hd.Response{data=string} "ok"
func (this *AdminUpdate) Do() error {
	var err error
	id, err := this.GetId()
	if err != nil {
		return err
	}
	po := &adminmodel.AdminUpdateForm{}
	err = this.Bind(po)
	if err != nil {
		return err
	}
	po.ID = id
	err = this.Update(po)
	if err != nil {
		return err
	}
	this.RepOk()
	return nil
}
func (this *AdminUpdate) Update(po *adminmodel.AdminUpdateForm) error {
	db := this.sc.Db
	tmpPo := &adminmodel.AdminUpdateForm{}
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
	if r := db.Select("phone", "name", "status", "memo", "email", "is_super_admin", "updated_at").Updates(po); r.Error != nil {
		return r.Error
	}
	//踢掉禁用人员
	if tmpPo.Status == "1" && po.Status == "0" {
		this.sc.Redis.Del(context.Background(), mymodel.GetAdminRedisLoginId(this.sc.Config.App.Name, int(tmpPo.ID)))
	}

	return nil
}

func (this *AdminUpdate) Valid(po *adminmodel.AdminUpdateForm) error {
	var ct = int64(0)
	if po.Phone != "" {
		if r := this.sc.Db.Model(po).Where("id != ? and account = ?",po.ID,po.Account).Count(&ct); r.Error != nil {
			return errs.WithMessage(r.Error, "校验失败")
		} else if ct != 0 {
			return errors.New("手机号已存在")
		}
	}

	if po.Email != "" {
		if r := this.sc.Db.Model(po).Where("id != ? and email = ?",po.ID, po.Email).Count(&ct); r.Error != nil {
			return errs.WithMessage(r.Error, "校验失败")
		} else if ct != 0 {
			return errors.New("Email已存在")
		}
	}

	return nil
}
