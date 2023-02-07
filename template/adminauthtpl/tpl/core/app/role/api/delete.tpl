package api

import (
	"{{.Module}}/internal/app/role/rolemodel"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/router/irouter"
	"errors"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"{{.Host}}/api/hd"
)

type RoleDel struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewRoleDel(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &RoleDel{hd.NewHd(c), c, sc}
}

//	@tags		角色管理
//	@summary	删除角色
//	@router		/api/role/:id [delete]
//	@param		id				path		int							true	"用户ID"
//	@param		Authorization	header		string						true	"token"
//	@success	200				{object}	hd.Response{data=string}	"ok"
func (this *RoleDel) Do() error {
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

func (this *RoleDel) Delete(id int64) error {
	db := this.sc.Db
	po := &rolemodel.RolePo{}
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

	this.sc.AuthCheck.LoadPolicy()
	return nil
}
