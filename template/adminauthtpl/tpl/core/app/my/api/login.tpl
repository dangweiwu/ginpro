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
	"github.com/google/uuid"
	"gorm.io/gorm"
	"{{.Host}}/api/hd"
	"strings"
	"time"
)

type Login struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

//	@tags			系统我的
//	@summary		登  录
//	@router			/api/login [post]
//	@description	errmsg1:400 登陆失败
//	@description	errmsg2:400 密码错误
//	@param			root	body		mymodel.LoginForm	true	"登陆账号密码"
//	@success		200		{object}	mymodel.LogRep		"登陆返回"
func NewLogin(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &Login{hd.NewHd(c), c, sc}
}

func (this *Login) Do() error {

	//数据源
	po := &mymodel.LoginForm{}
	err := this.Bind(po)
	if err != nil {
		return err
	}

	data, err := this.Login(po)
	if err != nil {
		return err
	}
	this.Rep(data)
	return nil
}
func (this *Login) Login(form *mymodel.LoginForm) (interface{}, error) {
	po, err := this.Valid(form)
	if err != nil {
		return nil, err
	}

	pwd := pkg.GetPassword(form.Password)
	if pwd != po.Password {
		return nil, errors.New("密码错误")
	}

	//同时只能有一个jwt登陆，可拓展踢人功能
	logincode, err := this.newLoginCode(po.ID)
	if err != nil {
		return nil, err
	}

	now := time.Now().Unix()
	if token, err := jwtx.GenToken(
		this.sc.Config.Jwt.Secret,
		now+this.sc.Config.Jwt.Exp,
		now+this.sc.Config.Jwt.Exp/2,
		po.ID,
		logincode,
		po.Role,
		po.IsSuperAdmin,
	); err != nil {
		return nil, this.ErrMsg("登陆失败", "jwt:"+err.Error())
	} else {
		// this.ctx.Header("Authorization", token)
		refleshToken, err := this.newRefreshToken(po.ID)
		if err != nil {
			return nil, err
		}
		return mymodel.LogRep{
			token,
			now + this.sc.Config.Jwt.Exp/2,
			refleshToken,
		}, nil

	}
}

func (this *Login) Valid(form *mymodel.LoginForm) (*adminmodel.AdminPo, error) {
	po := &adminmodel.AdminPo{}
	if r := this.sc.Db.Model(po).Where("account=?", form.Account).Take(po); r.Error != nil {
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

func (this *Login) newLoginCode(id int64) (string, error) {
	//登陆处理
	//登陆code 控制唯一登陆有效及踢人
	var logincode string
	if logincode = uuid.New().String(); logincode == "" {
		return "", this.ErrMsg("logincode is empty", "登陆失败")
	} else {
		logincode = strings.Split(logincode, "-")[0]
		if r := this.sc.Redis.Set(context.Background(), mymodel.GetAdminRedisLoginId(this.sc.Config.App.Name, int(id)), logincode, 0); r.Err() != nil {
			return "", this.ErrMsg("redis:"+r.Err().Error(), "登陆失败")
		}
	}
	return logincode, nil
}

// 刷新token生成
func (this *Login) newRefreshToken(id int64) (string, error) {
	var refreshToken string
	if refreshToken = uuid.New().String(); refreshToken == "" {
		return "", this.ErrMsg("登陆失败", "refreshToken is empty")
	} else {
		if r := this.sc.Redis.Set(context.Background(), mymodel.GetAdminRedisRefreshTokenId(this.sc.Config.App.Name, int(id)), refreshToken, time.Second*time.Duration(this.sc.Config.Jwt.Exp)); r.Err() != nil {
			return "", this.ErrMsg("redis:"+r.Err().Error(), "登陆失败")
		} else {
			return refreshToken, nil
		}
	}
}
