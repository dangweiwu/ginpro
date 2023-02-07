package api

import (
	"{{.Module}}/internal/app/auth/authmodel"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/router/irouter"
	"errors"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"{{.Host}}/api/hd"
)

type AuthDel struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewAuthDel(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &AuthDel{hd.NewHd(c), c, sc}
}

//	@tags		权限管理
//	@summary	删除权限
//	@router		/api/auth/:id [delete]
//	@param		id				path		int							true	"用户ID"
//	@param		Authorization	header		string						true	"token"
//	@success	200				{object}	hd.Response{data=string}	"ok"
func (this *AuthDel) Do() error {
	var err error
	id, err := this.GetId()
	if err != nil {
		return err
	}
	if err := this.Delete(id); err != nil {
		return err
	} else {
		this.sc.AuthCheck.LoadPolicy()
		this.RepOk()
		return nil
	}
}

func (this *AuthDel) Delete(id int64) error {
	db := this.sc.Db
	po := &authmodel.AuthPo{}
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
