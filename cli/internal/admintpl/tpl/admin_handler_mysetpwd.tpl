package handler

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/pkg"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/router/irouter"
	"{{.Module}}/internal/serctx"
	"context"
	"errors"
	"gs/api/hd"
	"github.com/gin-gonic/gin"
)

/*
修改我的密码
*/
type PasswordForm struct {
	Password    string `json:"password" binding:"required"`     //原始密码
	NewPassword string `json:"new_password" binding:"required"` //新密码
}

type MySetPwd struct {
	*hd.Hd
	ctx *gin.Context
	sc  *serctx.ServerContext
}

func NewMySetPwd(ctx *gin.Context, sc *serctx.ServerContext) irouter.IHandler {
	return &MySetPwd{hd.NewHd(ctx), ctx, sc}
}

// @tags    系统我的
// @summary 修改密码
// @router  /api/admin/my/password [post]
// @param   Authorization header   string                  true "token"
// @param   root          body     LoginForm               true "修改密码"
// @success 200           {object} hd.Response{data=string} "data=ok"
func (this *MySetPwd) Do() error {
	var err error
	uid, err := jwtx.GetUid(this.ctx)

	po := &PasswordForm{}

	err = this.Bind(po)
	if err != nil {
		return err
	}
	err = this.SetPwd(po, uid)
	if err != nil {
		return err
	}
	this.RepOk()
	return nil
}

func (this *MySetPwd) SetPwd(form *PasswordForm, id int64) error {
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

	this.sc.Redis.Del(context.Background(), adminmodel.GetAdminRedisLoginId(int(po.ID)))
	return r.Error
}
