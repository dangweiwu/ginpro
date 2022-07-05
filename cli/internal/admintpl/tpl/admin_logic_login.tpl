package logic

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/pkg"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/serctx"
	"errors"
	"gs/api/hd"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type AdminLogin struct {
	ctx    *gin.Context
	serctx *serctx.ServerContext
}

func NewAdminLogin(ctx *gin.Context, serCtx *serctx.ServerContext) *AdminLogin {
	return &AdminLogin{ctx, serCtx}
}

func (this *AdminLogin) Login(form *adminmodel.LoginForm) (interface{}, error) {
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
	if token, err := jwtx.GenToken(this.serctx.Config.Jwt.Secret, now+this.serctx.Config.Jwt.Exp, now+this.serctx.Config.Jwt.Exp/2, po.ID, logincode); err != nil {
		return nil, hd.ErrMsg("登陆失败", "jwt:"+err.Error())
	} else {
		// this.ctx.Header("Authorization", token)
		return map[string]interface{}{
			"Authorization": token,
			"Fresh":         now + this.serctx.Config.Jwt.Exp/2,
		}, nil
	}
}

func (this *AdminLogin) Valid(form *adminmodel.LoginForm) (*adminmodel.AdminPo, error) {
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
		if r := this.serctx.Redis.HMSet(adminmodel.RedisPre+strconv.Itoa(int(id)), map[string]interface{}{adminmodel.RedisLoginCode: logincode}); r.Err() != nil {
			return "", hd.ErrMsg("登陆失败", "redis:"+r.Err().Error())
		}
	}
	return logincode, nil
}
