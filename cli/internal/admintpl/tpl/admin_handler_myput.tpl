package handler

import (

	"errors"
	"gs/api/hd"

	"{{.Module}}/internal/router/irouter"
    "{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/serctx"

	"github.com/gin-gonic/gin"
	errs "github.com/pkg/errors"
	"gorm.io/gorm"
)

/*
修改我的信息
*/

func (this *MyPut) Do() error {
	var err error
	uid, err := jwtx.GetUid(this.ctx)

	po := &adminmodel.AdminPo4{}

	err = hd.Bind(this.ctx, po)
	if err != nil {
		return err
	}
	po.ID = uid
	err = this.Put(po)
	if err != nil {
		return err
	}
	hd.RepOk(this.ctx)
	return nil
}

type MyPut struct {
	ctx    *gin.Context
	serctx *serctx.ServerContext
}

func NewMyPut(ctx *gin.Context, serCtx *serctx.ServerContext) irouter.IHandler {
	return &MyPut{ctx, serCtx}
}

func (this *MyPut) Put(rawpo *adminmodel.AdminPo4) error {
	po := &adminmodel.AdminPo4{}
	//校验
	if r := this.serctx.Db.Model(po).Where("id=?", rawpo.ID).Take(po); r.Error != nil {
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
	if r := this.serctx.Db.Model(rawpo).Where("id=?", rawpo.ID).Select("phone", "name", "memo", "email").Updates(rawpo); r.Error != nil {
		return r.Error
	}
	return nil

}

func (this *MyPut) valid(po *adminmodel.AdminPo4) error {
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
