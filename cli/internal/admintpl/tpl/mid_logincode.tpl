package middler

/*校验code是否有效 无效则退出登陆
1. 放在token中间件之后
2. 必须有redis
*/
import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/serctx"
	"gs/api/hd"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/go-redis/redis"
)

func LoginCodeErrResponse(ctx *gin.Context) {
	ctx.JSON(401, hd.ErrMsg("鉴权已失效", ""))
	ctx.Abort()
}

func LoginCodeErrResponse1(ctx *gin.Context, msg string) {
	ctx.JSON(401, hd.ErrMsg("登录码校验失败", msg))
	ctx.Abort()
}

func LoginCodeErrResponse2(ctx *gin.Context) {
	ctx.JSON(401, hd.ErrMsg("该账号已下线", ""))
	ctx.Abort()
}

func LoginCode(sc *serctx.ServerContext) gin.HandlerFunc {
	return func(c *gin.Context) {
		code, err := jwtx.GetCode(c)
		if err != nil {
			LoginCodeErrResponse1(c, err.Error())
			return
		}
		uid, err := jwtx.GetUid(c)
		if err != nil {
			LoginCodeErrResponse1(c, err.Error())
			return
		}

		logincode, err := sc.Redis.Get(adminmodel.RedisPre + strconv.Itoa(int(uid))).Result()
		if err != nil {
			if err == redis.Nil {
				LoginCodeErrResponse(c)
			} else {
				LoginCodeErrResponse1(c, err.Error())
			}
			return
		}

		if logincode != code {
			LoginCodeErrResponse(c)
			return
		}
		c.Next()
	}
}
