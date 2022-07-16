package handler

import (
	"errors"
	"gs/api/hd"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"

	"{{.Module}}/internal/router/irouter"
	"{{.Module}}/internal/app/admin/adminmodel"
    "{{.Module}}/internal/serctx"
)

type AdminDel struct {
	ctx    *gin.Context
	serctx *serctx.ServerContext
}

func NewAdminDel(ctx *gin.Context, serCtx *serctx.ServerContext) irouter.IHandler {
	return &AdminDel{ctx, serCtx}
}
func (this *AdminDel) Do() error {
	var err error
	id, err := hd.GetId(this.ctx)
	if err != nil {
		return err
	}
	if err := this.Delete(id); err != nil {
		return err
	} else {
		hd.RepOk(this.ctx)
		return nil
	}
}

func (this *AdminDel) Delete(id int64) error {
	db := this.serctx.Db
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