package handler

import (
	"errors"
	"gs/api/hd"
	"strings"
	"time"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"gorm.io/gorm"
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/pkg"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/serctx"
	"{{.Module}}/internal/router/irouter"
)

type LoginForm struct {
	Account  string `binding:"required"`
	Password string `binging:"required"`
}

type AdminLogin struct {
	ctx    *gin.Context
	serctx *serctx.ServerContext
}

func NewAdminLogin(ctx *gin.Context, serCtx *serctx.ServerContext) irouter.IHandler {
	return &AdminLogin{ctx, serCtx}
}
func (this *AdminLogin) Do() error {

	//数据源
	po := &LoginForm{}
	err := hd.Bind(this.ctx, po)
	if err != nil {
		return err
	}

	data, err := this.Login(po)
	if err != nil {
		return err
	}
	hd.Rep(this.ctx, data)
	return nil
}
func (this *AdminLogin) Login(form *LoginForm) (interface{}, error) {
	po, err := this.Valid(form)
	if err != nil {
		return nil, err
	}

	pwd := pkg.GetPassword(form.Password)
	if pwd != po.Password {
		return nil, errors.New("密码错误")
	}

	logincode, err := this.newCode(po.ID)
	if err != nil {
		return nil, err
	}

	now := time.Now().Unix()
	if token, err := jwtx.GenToken(
		this.serctx.Config.Jwt.Secret,
		now+this.serctx.Config.Jwt.Exp,
		now+this.serctx.Config.Jwt.Exp/2,
		po.ID,
		logincode,
	); err != nil {
		return nil, hd.ErrMsg("登陆失败", "jwt:"+err.Error())
	} else {
		// this.ctx.Header("Authorization", token)
		return map[string]interface{}{
			"Authorization": token,
			"Fresh":         now + this.serctx.Config.Jwt.Exp/2,
		}, nil
	}
}

func (this *AdminLogin) Valid(form *LoginForm) (*adminmodel.AdminPo, error) {
	po := &adminmodel.AdminPo{}
	if r := this.serctx.Db.Model(po).Where("account=?", form.Account).Take(po); r.Error != nil {
		if r.Error == gorm.ErrRecordNotFound {
			return po, errors.New("账号不存在")
		} else {
			return po, r.Error
		}
	}

	if pkg.GetPassword(form.Password) != po.Password {
		return nil, errors.New("密码错误")
	}

	if po.Status == "0" {
		return nil, errors.New("账号被禁用")
	}

	return po, nil
}

func (this *AdminLogin) newCode(id int64) (string, error) {
	//登陆处理
	//登陆code 控制唯一登陆有效及踢人
	var logincode string
	if logincode = uuid.New().String(); logincode == "" {
		return "", hd.ErrMsg("登陆失败", "logincode is empty")
	} else {
		logincode = strings.Split(logincode, "-")[0]
		if r := this.serctx.Redis.Set(adminmodel.GetAdminId(int(id)), logincode, 0); r.Err() != nil {
			return "", hd.ErrMsg("登陆失败", "redis:"+r.Err().Error())
		}
	}
	return logincode, nil
}
