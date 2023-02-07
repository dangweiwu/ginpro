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

type AuthUpdate struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewAuthUpdate(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &AuthUpdate{hd.NewHd(c), c, sc}
}

//	@tags		权限管理
//	@summary	修改权限
//	@router		/api/auth/:id [put]
//	@param		id				path		int							true	"用户ID"
//	@param		Authorization	header		string						true	"token"
//	@param		root			body		authmodel.AuthUpdateForm	true	"修改信息"
//	@success	200				{object}	hd.Response{data=string}	"ok"
func (this *AuthUpdate) Do() error {
	var err error
	id, err := this.GetId()
	if err != nil {
		return err
	}
	po := &authmodel.AuthUpdateForm{}
	err = this.Bind(po)
	if err != nil {
		return err
	}
	po.ID = id
	err = this.Update(po)
	if err != nil {
		return err
	}

	this.sc.AuthCheck.LoadPolicy()
	this.RepOk()
	return nil
}

func (this *AuthUpdate) Update(po *authmodel.AuthUpdateForm) error {
	db := this.sc.Db
	tmpPo := &authmodel.AuthPo{}
	tmpPo.ID = po.ID
	if r := db.Model(tmpPo).Take(tmpPo); r.Error != nil {
		if r.Error == gorm.ErrRecordNotFound {
			return errors.New("记录不存在")
		} else {
			return r.Error
		}
	}
	//其他校验

	//更新
	if r := db.Updates(po); r.Error != nil {
		return r.Error
	}
	return nil
}
