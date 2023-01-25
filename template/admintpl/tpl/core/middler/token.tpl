package middler

import (
	"{{.Module}}/internal/ctx"
	"gs/api/hd"
	"errors"
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

func RefuseResponse(c *gin.Context) {
	c.JSON(401, hd.ErrMsg("", "鉴权失效"))
	c.Abort()
}

func ErrToken(c *gin.Context, err string) {
	c.JSON(400, hd.ErrMsg(err, "无效鉴权"))
	c.Abort()
}

//token 中间件

func TokenPase(sc *ctx.ServerContext) gin.HandlerFunc {
	sec := sc.Config.Jwt.Secret
	return func(c *gin.Context) {
		tk, err := request.ParseFromRequest(c.Request, request.AuthorizationHeaderExtractor, func(t *jwt.Token) (interface{}, error) {
			return []byte(sec), nil
		})

		if errors.Is(err, jwt.ErrTokenExpired) {
			RefuseResponse(c)
			return
		}
		if err != nil {
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
