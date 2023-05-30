package api

/*
token刷新
*/
import (
	"{{.Module}}/internal/app/my/mymodel"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/router/irouter"
	"{{.Module}}/internal/ctx"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"{{.Host}}/api/hd"
	"time"
	"context"
)



type RefreshToken struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewRefreshToken(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &RefreshToken{hd.NewHd(c), c, sc}
}
// @x-group		{"key":"my","name":"系统我的","order":0,"desc":"系统我的","inorder":5}
// @tags        系统我的
// @summary     刷新token
// @router      /api/token/refresh [post]
// @description 刷新token
// @description 200时返回与登陆后获取的返回一样
// @param   Authorization header   string              true " " extensions(x-name=鉴权,x-value=[TOKEN])
// @param       root          body     mymodel.RefreshTokeForm   true "刷新token"
// @success     200           {object} mymodel.LogRep " "
func (this *RefreshToken) Do() error {

	form := &mymodel.RefreshTokeForm{}
	if err := this.Bind(form); err != nil {
		return err
	}

	uid, err := jwtx.GetUid(this.ctx)
	if err != nil {
		return err
	}

	//刷新token检验
	r, err := this.sc.Redis.Get(context.Background(), mymodel.GetAdminRedisRefreshTokenId(this.sc.Config.App.Name, int(uid))).Result()
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

func (this *RefreshToken) RefreshToken(uid int64) (interface{}, error) {
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
		return mymodel.LogRep{
			token,
			now + this.sc.Config.Jwt.Exp/2,
			newRefreshToken,
		}, nil
	}
}

// 刷新token生成
func (this *RefreshToken) newRefreshToken(id int64) (string, error) {
	var refreshToken string
	if refreshToken = uuid.New().String(); refreshToken == "" {
		return "", this.ErrMsg("刷新失败", "refreshToken is empty")
	} else {
		if r := this.sc.Redis.Set(context.Background(), mymodel.GetAdminRedisRefreshTokenId(this.sc.Config.App.Name, int(id)), refreshToken,  time.Second*time.Duration(this.sc.Config.Jwt.Exp)); r.Err() != nil {
			return "", this.ErrMsg("刷新失败", "redis:"+r.Err().Error())
		} else {
			return refreshToken, nil
		}
	}
}