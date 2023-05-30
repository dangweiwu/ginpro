package api

import (
	"errors"
	"{{.Host}}/api/hd"

	"{{.Module}}/internal/app/my/mymodel"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/router/irouter"
	"{{.Module}}/internal/ctx"

	"github.com/gin-gonic/gin"
	errs "github.com/pkg/errors"
	"gorm.io/gorm"
)

/*
修改我的信息
*/

type MyUpdate struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewMyUpdate(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &MyUpdate{hd.NewHd(c), c, sc}
}

// @x-group		{"key":"my","name":"系统我的","order":0,"desc":"系统我的","inorder":2}
// @tags    系统我的
// @summary 修改信息
// @router  /api/my [put]
// @param   Authorization header   string              true " " extensions(x-name=鉴权,x-value=[TOKEN])
// @param   root          body     mymodel.MyForm      true "修改信息"
// @success 200           {string} string "{data:'ok'}"
func (this *MyUpdate) Do() error {
	var err error
	uid, err := jwtx.GetUid(this.ctx)

	po := &mymodel.MyForm{}

	err = this.Bind(po)
	if err != nil {
		return err
	}
	po.ID = uid
	err = this.Update(po)
	if err != nil {
		return err
	}
	this.RepOk()
	return nil
}

func (this *MyUpdate) Update(rawpo *mymodel.MyForm) error {
	po := &mymodel.MyForm{}
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

func (this *MyUpdate) valid(po *mymodel.MyForm) error {
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
