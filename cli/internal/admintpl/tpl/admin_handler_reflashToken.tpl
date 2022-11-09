package handler

/*
token刷新
*/
import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/router/irouter"
	"{{.Module}}/internal/serctx"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"gs/api/hd"
	"strings"
	"time"
	"context"
)

type RefreshTokeForm struct {
	RefreshToken string `json:"refresh_token" binding:"required""` //刷新token
}

type ReflashToken struct {
	*hd.Hd
	ctx *gin.Context
	sc  *serctx.ServerContext
}

func NewReflashToken(ctx *gin.Context, sc *serctx.ServerContext) irouter.IHandler {
	return &ReflashToken{hd.NewHd(ctx), ctx, sc}
}

// @tags        系统用户
// @summary     刷新token
// @router      /api/token/reflesh [post]
// @description 刷新token
// @description 200时返回与登陆后获取的返回一样
// @param       Authorization header   string            true "token"
// @param       root          body     RefreshTokeForm   true "刷新token"
// @success     200           {object} adminmodel.LogRep "登陆返回"
func (this *ReflashToken) Do() error {

	form := &RefreshTokeForm{}
	if err := this.Bind(form); err != nil {
		return err
	}

	uid, err := jwtx.GetUid(this.ctx)
	if err != nil {
		return err
	}

	//刷新token检验
	r, err := this.sc.Redis.Get(context.Background(), adminmodel.GetAdminRedisRefreshTokenId(int(uid))).Result()
	if err != nil {
		return err
	}

	if r != form.RefreshToken {
		this.ctx.JSON(401, hd.ErrMsg("refreshtoken已失效", ""))
		return nil
	}
	//数据源
	data, err := this.RefreshToken(uid)
	if err != nil {
		return err
	}

	this.Rep(data)
	return nil
}

func (this *ReflashToken) RefreshToken(uid int64) (interface{}, error) {
	// logincode, err := this.newCode(uid)

	logincode, err := jwtx.GetCode(this.ctx)
	if err != nil {
		return nil, err
	}

	now := time.Now().Unix()
	if token, err := jwtx.GenToken(
		this.sc.Config.Jwt.Secret,
		now+this.sc.Config.Jwt.Exp,
		now+this.sc.Config.Jwt.Exp/2,
		uid,
		logincode,
	); err != nil {
		return nil, this.ErrMsg("刷新失败", "jwt:"+err.Error())
	} else {
		// this.ctx.Header("Authorization", token)
		newRefreshToken, err := this.newRefreshToken(uid)
		if err != nil {
			return "", err
		}
		return adminmodel.LogRep{
			token,
			now + this.sc.Config.Jwt.Exp/2,
			newRefreshToken,
		}, nil
	}
}

// 刷新token生成
func (this *ReflashToken) newRefreshToken(id int64) (string, error) {
	var refreshToken string
	if refreshToken = uuid.New().String(); refreshToken == "" {
		return "", this.ErrMsg("刷新失败", "refreshToken is empty")
	} else {
		refreshToken = strings.Split(refreshToken, "-")[0]
		if r := this.sc.Redis.Set(context.Background(), adminmodel.GetAdminRedisRefreshTokenId(int(id)), refreshToken, 0); r.Err() != nil {
			return "", this.ErrMsg("刷新失败", "redis:"+r.Err().Error())
		} else {
			return refreshToken, nil
		}
	}
}