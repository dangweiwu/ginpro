package handler

/*
token刷新
*/
import (
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/router/irouter"
	"{{.Module}}/internal/serctx"
	"gs/api/hd"
	"time"

	"github.com/gin-gonic/gin"
)

func (this *ReflashToken) Do() error {

	//数据源
	data, err := this.ReflashToken()
	if err != nil {
		return err
	}

	hd.Rep(this.ctx, data)
	return nil
}

type ReflashToken struct {
	ctx    *gin.Context
	serctx *serctx.ServerContext
}

func NewReflashToken(ctx *gin.Context, serCtx *serctx.ServerContext) irouter.IHandler {
	return &ReflashToken{ctx, serCtx}
}

func (this *ReflashToken) ReflashToken() (interface{}, error) {
	// logincode, err := this.newCode(uid)

	uid, err := jwtx.GetUid(this.ctx)
	if err != nil {
		return nil, err
	}
	logincode, err := jwtx.GetCode(this.ctx)
	if err != nil {
		return nil, err
	}

	now := time.Now().Unix()
	if token, err := jwtx.GenToken(
		this.serctx.Config.Jwt.Secret,
		now+this.serctx.Config.Jwt.Exp,
		now+this.serctx.Config.Jwt.Exp/2,
		uid, 
		logincode
	); err != nil {
		return nil, hd.ErrMsg("刷新失败", "jwt:"+err.Error())
	} else {
		// this.ctx.Header("Authorization", token)
		return map[string]interface{}{
			"Authorization": token,
			"Fresh":         now + this.serctx.Config.Jwt.Exp/2,
		}, nil
	}
}
