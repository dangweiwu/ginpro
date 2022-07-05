package logic

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/serctx"
	"errors"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type AdminDel struct {
	ctx    *gin.Context
	serctx *serctx.ServerContext
}

func NewAdminDel(ctx *gin.Context, serCtx *serctx.ServerContext) *AdminDel {
	return &AdminDel{ctx, serCtx}
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
