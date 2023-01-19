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
	"strings"
	"time"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type LoginForm struct {
	Account  string `json:"account" binging:"required"`  //账号
	Password string `json:"password" binging:"required"` //密码
}

type AdminLogin struct {
	*hd.Hd
	ctx *gin.Context
	sc  *serctx.ServerContext
}

// @tags        系统我的
// @summary     登  录
// @router      /api/admin/login [post]
// @description errmsg1:400 登陆失败
// @description errmsg2:400 密码错误
// @param       root body     LoginForm         true "登陆账号密码"
// @success     200  {object} adminmodel.LogRep "登陆返回"
func NewAdminLogin(ctx *gin.Context, sc *serctx.ServerContext) irouter.IHandler {
	return &AdminLogin{hd.NewHd(ctx), ctx, sc}
}

func (this *AdminLogin) Do() error {

	//数据源
	po := &LoginForm{}
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
func (this *AdminLogin) Login(form *LoginForm) (interface{}, error) {
	po, err := this.Valid(form)
	if err != nil {
		return nil, err
	}

	pwd := pkg.GetPassword(form.Password)
	if pwd != po.Password {
		return nil, errors.New("密码错误")
	}

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
	); err != nil {
		return nil, this.ErrMsg("登陆失败", "jwt:"+err.Error())
	} else {
		// this.ctx.Header("Authorization", token)
		refleshToken, err := this.newRefreshToken(po.ID)
		if err != nil {
			return nil, err
		}
		return adminmodel.LogRep{
			token,
			now + this.sc.Config.Jwt.Exp/2,
			refleshToken,
		}, nil

	}
}

func (this *AdminLogin) Valid(form *LoginForm) (*adminmodel.AdminPo, error) {
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

func (this *AdminLogin) newLoginCode(id int64) (string, error) {
	//登陆处理
	//登陆code 控制唯一登陆有效及踢人
	var logincode string
	if logincode = uuid.New().String(); logincode == "" {
		return "", this.ErrMsg("登陆失败", "logincode is empty")
	} else {
		logincode = strings.Split(logincode, "-")[0]
		if r := this.sc.Redis.Set(context.Background(), adminmodel.GetAdminRedisLoginId(int(id)), logincode, 0); r.Err() != nil {
			return "", this.ErrMsg("登陆失败", "redis:"+r.Err().Error())
		}
	}
	return logincode, nil
}

// 刷新token生成
func (this *AdminLogin) newRefreshToken(id int64) (string, error) {
	var refreshToken string
	if refreshToken = uuid.New().String(); refreshToken == "" {
		return "", this.ErrMsg("登陆失败", "refreshToken is empty")
	} else {
		refreshToken = strings.Split(refreshToken, "-")[0]
		if r := this.sc.Redis.Set(context.Background(), adminmodel.GetAdminRedisRefreshTokenId(int(id)), refreshToken, 0); r.Err() != nil {
			return "", this.ErrMsg("登陆失败", "redis:"+r.Err().Error())
		} else {
			return refreshToken, nil
		}
	}
}
