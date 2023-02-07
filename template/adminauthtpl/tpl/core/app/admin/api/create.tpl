package api

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/pkg"
	"{{.Module}}/internal/router/irouter"
	"errors"
	"{{.Host}}/api/hd"
	"github.com/gin-gonic/gin"
	errs "github.com/pkg/errors"
)

type AdminCreate struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewAdminCreate(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &AdminCreate{hd.NewHd(c), c, sc}
}

//	@tags		系统用户
//	@summary	创建用户
//	@router		/api/admin [post]
//	@param		Authorization	header		string						true	"token"
//	@param		root			body		adminmodel.AdminForm		true	"登陆账号密码"
//	@success	200				{object}	hd.Response{data=string}	"ok"
func (this *AdminCreate) Do() error {

	//数据源
	po := &adminmodel.AdminForm{}
	err := this.Bind(po)
	if err != nil {
		return err
	}

	err = this.Create(po)
	if err != nil {
		return err
	}
	this.RepOk()
	return nil
}

func (this *AdminCreate) Create(po *adminmodel.AdminForm) error {
	db := this.sc.Db
	//验证是否已创建 或者其他检查
	if err := this.Valid(po); err != nil {
		return err
	}

	po.Password = pkg.GetPassword(po.Password)
	if po.IsSuperAdmin == "1" {
		po.Role = ""
	}
	if r := db.Create(po); r.Error != nil {
		return r.Error
	}
	return nil
}

func (this *AdminCreate) Valid(po *adminmodel.AdminForm) error {
	db := this.sc.Db
	var ct = int64(0)
	if r := db.Model(po).Where("account = ?", po.Account).Count(&ct); r.Error != nil {
		return errs.WithMessage(r.Error, "校验失败")
	} else if ct != 0 {
		return errors.New("账号已存在")
	}

	if po.Phone != "" {
		if r := db.Model(po).Where("phone = ?", po.Phone).Count(&ct); r.Error != nil {
			return errs.WithMessage(r.Error, "校验失败")
		} else if ct != 0 {
			return errors.New("手机号已存在")
		}
	}

	if po.Email != "" {
		if r := db.Model(po).Where("email = ?", po.Email).Count(&ct); r.Error != nil {
			return errs.WithMessage(r.Error, "校验失败")
		} else if ct != 0 {
			return errors.New("Email已存在")
		}
	}
	return nil
}
