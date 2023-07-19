package api

import (
	"errors"
	"{{.Host}}/api/hd"
	"{{.Module}}/internal/app/my/mymodel"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/router/irouter"
	"{{.Module}}/internal/ctx"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

/*
获取我的信息
*/
type MyInfo struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewMyInfo(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &MyInfo{hd.NewHd(c), c, sc}
}

// @x-group		{"key":"my","inorder":3}
// @tags    系统我的
// @summary 查询信息
// @router  /api/my [get]
// @param   Authorization header   string              true " " extensions(x-name=鉴权,x-value=[TOKEN])
// @success 200           {object} mymodel.MyInfo " "
func (this *MyInfo) Do() error {

	uid, err := jwtx.GetUid(this.ctx)
	if err != nil {
		return err
	}

	po := &mymodel.MyInfo{}
	if r := this.sc.Db.Model(po).Where("id = ?", uid).Take(po); r.Error != nil {
		if r.Error == gorm.ErrRecordNotFound {
			return errors.New("记录不存在")
		} else {
			return r.Error
		}
	}
	this.Rep(po)
	return nil
}
