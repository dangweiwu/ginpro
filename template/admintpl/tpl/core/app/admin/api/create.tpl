package api

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/pkg"
	"{{.Module}}/internal/router/irouter"
	"{{.Module}}/internal/ctx"
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

// @tags    系统用户
// @summary 创建用户
// @x-group		{"key":"adminuser","name":"系统用户","order":1,"desc":"系统用户管理","inorder":1}
// @router  /api/admin [post]
// @param   Authorization header   string                 true " " extensions(x-name=鉴权,x-value=[TOKEN])
// @param   root          body     adminmodel.AdminForm   true " "
// @success 200           {string} string  "{data:'ok'}"
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

    /*
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
	*/
	return nil
}
