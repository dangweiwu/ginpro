package api

import (
	"errors"
	"github.com/gin-gonic/gin"
    "{{.Module}}/internal/pkg/jwtx"
	"gorm.io/gorm"
	"{{.Host}}/api/hd"
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/router/irouter"
	"{{.Module}}/internal/ctx"
)

type AdminDel struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewAdminDel(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &AdminDel{hd.NewHd(c), c, sc}
}

// @tags    系统用户
// @summary 删除用户
// @x-group		{"key":"adminuser","inorder":3}
// @router  /api/admin/:id [delete]
// @param   Authorization header   string                   true " " extensions(x-name=鉴权,x-value=[TOKEN])
// @param   id            path     int                      true " "  extensions(x-name=用户ID,x-value=1)
// @success 200           {string} string  "{data:'ok'}"
func (this *AdminDel) Do() error {
	var err error
	id, err := this.GetId()
	if err != nil {
		return err
	}

    uid, err := jwtx.GetUid(this.ctx)
    if err != nil {
        return err
    }

    if id == uid {
        return errors.New("禁止删除自己")
    }

	if err := this.Delete(id); err != nil {
		return err
	} else {
		this.RepOk()
		return nil
	}
}

func (this *AdminDel) Delete(id int64) error {
	db := this.sc.Db
	po := &adminmodel.AdminPo{}
	po.ID = id
	if r := db.Take(po); r.Error != nil {
		if r.Error == gorm.ErrRecordNotFound {
			return errors.New("记录不存在")
		} else {
			return r.Error
		}
	}
	if r := db.Delete(po); r.Error != nil {
		return r.Error
	}
	return nil
}
