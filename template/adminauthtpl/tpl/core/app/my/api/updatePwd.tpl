package api

import (
	"context"
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/my/mymodel"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/pkg"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/router/irouter"
	"errors"
	"github.com/gin-gonic/gin"
	"{{.Host}}/api/hd"
)

/*
修改我的密码
*/

type UpdatePwd struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewMyUpdatePwd(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &UpdatePwd{hd.NewHd(c), c, sc}
}

//	@tags		系统我的
//	@summary	修改密码
//	@router		/api/admin/my/password [post]
//	@param		Authorization	header		string						true	"token"
//	@param		root			body		mymodel.LoginForm			true	"修改密码"
//	@success	200				{object}	hd.Response{data=string}	"data=ok"
func (this *UpdatePwd) Do() error {
	var err error
	uid, err := jwtx.GetUid(this.ctx)

	po := &mymodel.PasswordForm{}

	err = this.Bind(po)
	if err != nil {
		return err
	}
	err = this.UpdatePwd(po, uid)
	if err != nil {
		return err
	}
	this.RepOk()
	return nil
}

func (this *UpdatePwd) UpdatePwd(form *mymodel.PasswordForm, id int64) error {
	po := &adminmodel.AdminPo{}
	if r := this.sc.Db.Model(po).Where("id=?", id).Take(po); r.Error != nil {
		return r.Error
	}

	//校验旧密码是否正确
	if pkg.GetPassword(form.Password) != po.Password {
		return errors.New("原密码错误")
	}
	po.Password = pkg.GetPassword(form.NewPassword)
	r := this.sc.Db.Model(po).Select("password").Updates(po)

	this.sc.Redis.Del(context.Background(), mymodel.GetAdminRedisLoginId(this.sc.Config.App.Name, int(po.ID)))
	return r.Error
}
