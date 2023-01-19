package handler

import (
	"errors"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"gs/api/hd"

	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/router/irouter"
	"{{.Module}}/internal/serctx"
)

type AdminDel struct {
	*hd.Hd
	ctx *gin.Context
	sc  *serctx.ServerContext
}

func NewAdminDel(ctx *gin.Context, sc *serctx.ServerContext) irouter.IHandler {
	return &AdminDel{hd.NewHd(ctx), ctx, sc}
}

// @tags    系统用户
// @summary 删除用户
// @router  /api/admin/:id [delete]
// @param   id            path     int                      true "用户ID"
// @param   Authorization header   string                   true "token"
// @success 200           {object} hd.Response{data=string} "ok"
func (this *AdminDel) Do() error {
	var err error
	id, err := this.GetId()
	if err != nil {
		return err
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
