package api

import (
	"{{.Module}}/internal/app/my/mymodel"
	"{{.Module}}/internal/app/role/rolemodel"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/router/irouter"
	"context"
	"encoding/json"
	"errors"
	"github.com/gin-gonic/gin"
	"github.com/go-redis/redis/v8"
	"gorm.io/gorm"
	"{{.Host}}/api/hd"
	"time"
)

//获取所有权限

type MyAuth struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewMyAuth(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &MyAuth{hd.NewHd(c), c, sc}
}

// @x-group	{"key":"my","name":"系统我的","inorder":7}
// @tags		系统我的
// @summary	获取权限
// @router		/api/my-auth [get]
// @param		Authorization	header		string		true	" "	extensions(x-name=鉴权,x-value=[TOKEN])
// @success	200				{object}	[]string	"{'data':[auth1....]}"
// @success	401				{object}	string		"{'msg':'角色已被禁用'}"
// @success	400				{object}	string		"{'msg':'角色不存在'}"
func (this *MyAuth) Do() error {

	roleCode, err := jwtx.GetRole(this.ctx)
	if err != nil {
		return err
	}
	rolePo := &rolemodel.RolePo{}
	r, err := this.sc.Redis.Get(context.Background(), mymodel.ROLE_STATUS+roleCode).Result()
	if err == redis.Nil {
		//不存在从数据库里捞数据

		if r := this.sc.Db.Model(rolePo).Where("code=?", roleCode).Take(rolePo); r.Error != nil {
			if r.Error == gorm.ErrRecordNotFound {
				return errors.New("角色不存在")
			}
			return r.Error
		}
		this.sc.Redis.Set(context.Background(), mymodel.ROLE_STATUS+roleCode, rolePo.Status, time.Hour*24*7)
		if rolePo.Status == "0" {
			this.ctx.JSON(401, map[string]string{"data": "角色已被禁用"})
			this.ctx.Abort()
			return nil
		}
	} else {
		if r == "0" {
			this.ctx.JSON(401, map[string]string{"data": "角色已被禁用"})
			this.ctx.Abort()
			return nil
		}
	}
	authstring, err := this.sc.Redis.Get(context.Background(), mymodel.ROLE_AUTH+roleCode).Result()
	if err == redis.Nil {
		if rolePo == nil {
			if r := this.sc.Db.Model(rolePo).Where("code=?", roleCode).Take(rolePo); r.Error != nil {
				if r.Error == gorm.ErrRecordNotFound {
					return errors.New("该角色不存在")
				}
				return r.Error
			}
		}

		authstr := ""
		if r, err := json.Marshal(rolePo.Auth); err != nil {
			authstr = "[]"
		} else {
			authstr = string(r)
		}
		this.sc.Redis.Set(context.Background(), mymodel.ROLE_AUTH+roleCode, authstr, time.Hour*24*7)
		hd.Rep(this.ctx, hd.Response{rolePo.Auth})
		return nil
	}
	rd := []string{}
	if err := json.Unmarshal([]byte(authstring), &rd); err != nil {
		return err
	}
	hd.Rep(this.ctx, hd.Response{rd})

	return nil
}

