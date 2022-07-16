package handler

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/pkg"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/router/irouter"
	"{{.Module}}/internal/serctx"
	"errors"
	"gs/api/hd"

	"github.com/gin-gonic/gin"
)

/*
修改我的密码
*/
type PasswordForm struct {
	Password    string `binding:"required"`
	NewPassword string `binding:"required"`
}

type MySetPwd struct {
	ctx    *gin.Context
	serctx *serctx.ServerContext
}

func NewMySetPwd(ctx *gin.Context, serCtx *serctx.ServerContext) irouter.IHandler {
	return &MySetPwd{ctx, serCtx}
}
func (this *MySetPwd) Do() error {
	var err error
	uid, err := jwtx.GetUid(this.ctx)

	po := &PasswordForm{}

	err = hd.Bind(this.ctx, po)
	if err != nil {
		return err
	}
	err = this.SetPwd(po, uid)
	if err != nil {
		return err
	}
	hd.RepOk(this.ctx)
	return nil
}

func (this *MySetPwd) SetPwd(form *PasswordForm, id int64) error {
	po := &adminmodel.AdminPo{}
	if r := this.serctx.Db.Model(po).Where("id=?", id).Take(po); r.Error != nil {
		return r.Error
	}

	//校验旧密码是否正确
	if pkg.GetPassword(form.Password) != po.Password {
		return errors.New("原密码错误")
	}
	po.Password = pkg.GetPassword(form.NewPassword)
	r := this.serctx.Db.Model(po).Select("password").Updates(po)

	this.serctx.Redis.Del(adminmodel.GetAdminId(int(po.ID)))
	return r.Error
}
