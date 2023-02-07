package jwtx

import (
	"errors"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v4"
)

// jwt生成
const (
	Code    = "code"
	Fresh   = "fresh"
	Uid     = "uid"
	Role    = "role"
	IsSuper = "super"
)

//第一种方式
/*
secrectKey 密钥
exp 过期时间
uid 用户id
code 登陆id
fresh 刷新时间
*/
func GenToken(secretKey string, exp, fresh, uid int64, code, role, isSuper string) (string, error) {
	claims := make(jwt.MapClaims) //数据仓声明
	now := time.Now().Unix()

	claims["exp"] = exp
	claims["iat"] = now
	claims[Uid] = uid
	claims[Code] = code
	claims[Fresh] = fresh
	claims[Role] = role
	claims[IsSuper] = isSuper
	token := jwt.New(jwt.SigningMethodHS256) //token对象
	token.Claims = claims                    //token添加数据仓
	return token.SignedString([]byte(secretKey))
}

// jwt获取
func GetUid(ctx *gin.Context) (int64, error) {
	if _id, has := ctx.Get(Uid); has {
		if id, ok := _id.(float64); ok {
			return int64(id), nil
		}
	}
	return 0, errors.New("no uid from ctx")
}

// code 获取
func GetCode(ctx *gin.Context) (string, error) {
	if _tmp, has := ctx.Get(Code); has {
		if __tmp, ok := _tmp.(string); ok {
			return __tmp, nil
		}
	}
	return "", errors.New("no code from ctx")
}

func GetRole(ctx *gin.Context) (string, error) {
	if _tmp, has := ctx.Get(Role); has {
		if __tmp, ok := _tmp.(string); ok {
			return __tmp, nil
		}
	}
	return "", errors.New("no code from ctx")
}

func GetIsSuper(ctx *gin.Context) (bool, error) {
	if _tmp, has := ctx.Get(IsSuper); has {
		if __tmp, ok := _tmp.(string); ok {
			return __tmp == "1", nil
		}
	}
	return false, errors.New("no code from ctx")
}
