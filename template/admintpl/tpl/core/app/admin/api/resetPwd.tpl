package api

import (
    "time"
	"math/rand"
    "{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/my/mymodel"
	"{{.Module}}/internal/pkg"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/router/irouter"
	"{{.Module}}/internal/ctx"
    "context"
	"errors"
	"gs/api/hd"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

/*
重置账号密码
*/

type ResetPassword struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewResetPassword(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &ResetPassword{hd.NewHd(c), c, sc}
}

// @tags    系统用户
// @summary 修改密码
// @description 默认密码为系统设置密码。
// @description 修改后用户会被踢下线。
// @router  /api/admin/resetpwd/:id [put]
// @param   id            path     int                      true "用户ID"
// @param   Authorization header   string                   true "token"
// @success 200           {object} hd.Response{data=string} "new-password"
func (this *ResetPassword) Do() error {
	var err error
	id, err := this.GetId()
	if err != nil {
		return err
	}
	po := &adminmodel.AdminPo{}
	po.ID = id
	pwd,err := this.ResetPassword(po)
	if err != nil {
		return err
	}
	this.Rep(hd.Response{pwd})
	return nil
}

func (this *ResetPassword) ResetPassword(rawPo *adminmodel.AdminPo) (string,error) {

	id, err := jwtx.GetUid(this.ctx)
	if err != nil {
		return "",err
	}
	if id == rawPo.ID {
		return "",errors.New("不能重置自己密码")
	}

	po := &adminmodel.AdminPo{}
	if r := this.sc.Db.Model(po).Where("id=?", rawPo.ID).Take(po); r.Error != nil {
		if r.Error == gorm.ErrRecordNotFound {
			return "",errors.New("记录不存在")
		} else {
			return "",r.Error
		}
	}

    _pwd:=this.newPwd()
	pwd := pkg.GetPassword(_pwd)
	r := this.sc.Db.Model(po).Update("password", pwd)

	//踢出在线
	this.sc.Redis.Del(context.Background(), mymodel.GetAdminRedisLoginId(this.sc.Config.App.Name, int(po.ID)))

	//删除刷新token
	this.sc.Redis.Del(context.Background(), mymodel.GetAdminRedisRefreshTokenId(this.sc.Config.App.Name, int(po.ID)))
	return _pwd,r.Error
}

// 生成三位字符，三位数字的密码
var ltes = "abcdefghijkmnpqrstuvwxyz"
var nums = "0123456789"

func (this *ResetPassword) newPwd() string{

    rt := ""
    for i := 0; i < 3; i++ {
        rand.Seed(time.Now().UnixNano() + int64(rand.Intn(100)))
        rt += string(ltes[rand.Intn(len(ltes))])
    }
    for i := 0; i < 3; i++ {
        rand.Seed(time.Now().UnixNano() + int64(rand.Intn(100)))
        rt += string(nums[rand.Intn(len(nums))])
    }
    return rt
}