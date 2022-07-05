package middler

import (
	"{{.Module}}/internal/serctx"
	"gs/api/hd"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v4"
	"github.com/golang-jwt/jwt/v4/request"
)

const (
	jwtAudience    = "aud"
	jwtExpire      = "exp"
	jwtId          = "jti"
	jwtIssueAt     = "iat"
	jwtIssuer      = "iss"
	jwtNotBefore   = "nbf"
	jwtSubject     = "sub"
	noDetailReason = "no detail reason"
)

func RefuseResponse(ctx *gin.Context) {
	ctx.JSON(403, hd.ErrMsg("鉴权失效", ""))
	ctx.Abort()
}

func ErrToken(ctx *gin.Context, err string) {
	ctx.JSON(400, hd.ErrMsg("无效鉴权", err))
	ctx.Abort()
}

//token 中间件

func TokenPase(serCtx *serctx.ServerContext) gin.HandlerFunc {
	sec := serCtx.Config.Jwt.Secret
	return func(c *gin.Context) {
		tk, err := request.ParseFromRequest(c.Request, request.AuthorizationHeaderExtractor, func(t *jwt.Token) (interface{}, error) {
			return []byte(sec), nil
		})
		if err != nil {
			// fmt.Println("@@", err)
			ErrToken(c, err.Error())
			return
		}

		claims, ok := tk.Claims.(jwt.MapClaims)
		if !ok {
			RefuseResponse(c)
			return
		}
		for k, v := range claims {
			switch k {
			case jwtAudience, jwtExpire, jwtId, jwtIssueAt, jwtIssuer, jwtNotBefore, jwtSubject:
				// ignore the standard claims
			default:
				c.Set(k, v)
			}
		}
		c.Next()
	}
}
