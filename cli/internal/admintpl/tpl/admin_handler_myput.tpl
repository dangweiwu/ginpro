package handler

import (
	"errors"
	"gs/api/hd"

	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/router/irouter"
	"{{.Module}}/internal/serctx"

	"github.com/gin-gonic/gin"
	errs "github.com/pkg/errors"
	"gorm.io/gorm"
)

/*
修改我的信息
*/

type MyPut struct {
	*hd.Hd
	ctx *gin.Context
	sc  *serctx.ServerContext
}

func NewMyPut(ctx *gin.Context, sc *serctx.ServerContext) irouter.IHandler {
	return &MyPut{hd.NewHd(ctx), ctx, sc}
}

// @tags    系统我的
// @summary 修改信息
// @router  /api/admin [put]
// @param   Authorization header   string                   true "token"
// @param   root          body     adminmodel.AdminPo4      true "修改信息"
// @success 200           {object} hd.Response{data=string} "ok"
func (this *MyPut) Do() error {
	var err error
	uid, err := jwtx.GetUid(this.ctx)

	po := &adminmodel.AdminPo4{}

	err = this.Bind(po)
	if err != nil {
		return err
	}
	po.ID = uid
	err = this.Put(po)
	if err != nil {
		return err
	}
	this.RepOk()
	return nil
}

func (this *MyPut) Put(rawpo *adminmodel.AdminPo4) error {
	po := &adminmodel.AdminPo4{}
	//校验
	if r := this.sc.Db.Model(po).Where("id=?", rawpo.ID).Take(po); r.Error != nil {
		if r.Error == gorm.ErrRecordNotFound {
			return errors.New("记录不存在")
		} else {
			return r.Error
		}
	}

	if err := this.valid(rawpo); err != nil {
		return err
	}
	//更新
	if r := this.sc.Db.Model(rawpo).Select("phone", "name", "memo", "email").Updates(rawpo); r.Error != nil {
		return r.Error
	}
	return nil

}

func (this *MyPut) valid(po *adminmodel.AdminPo4) error {
	var ct = int64(0)

	if po.Phone != "" {
		if r := this.sc.Db.Model(po).Where("account = ?", po.Phone).Count(&ct); r.Error != nil {
			return errs.WithMessage(r.Error, "校验失败")
		} else if ct != 0 {
			return errors.New("手机号已存在")
		}
	}

	if po.Email != "" {
		if r := this.sc.Db.Model(po).Where("email = ?", po.Email).Count(&ct); r.Error != nil {
			return errs.WithMessage(r.Error, "校验失败")
		} else if ct != 0 {
			return errors.New("Email已存在")
		}
	}
	return nil
}
