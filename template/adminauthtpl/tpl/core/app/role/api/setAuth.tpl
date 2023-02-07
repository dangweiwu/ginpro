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

type SetAuth struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewSetAuth(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &SetAuth{hd.NewHd(c), c, sc}
}

//	@tags		角色管理
//	@summary	设定权限
//	@router		/api/role/auth/:id [put]
//	@param		id				path		int							true	"角色ID"
//	@param		Authorization	header		string						true	"token"
//	@param		root			body		rolemodel.RoleAuthForm		true	"修改角色"
//	@success	200				{object}	hd.Response{data=string}	"ok"
func (this *SetAuth) Do() error {
	var err error
	id, err := this.GetId()
	if err != nil {
		return err
	}

	po := &rolemodel.RoleAuthForm{}
	err = this.Bind(po)
	if err != nil {
		return err
	}
	po.ID = id
	if err := this.Update(po); err != nil {
		return err
	}
	this.RepOk()
	return nil
}

func (this *SetAuth) Update(po *rolemodel.RoleAuthForm) error {
	db := this.sc.Db
	tmpPo := &rolemodel.RolePo{}
	if r := db.Model(tmpPo).Take(tmpPo); r.Error != nil {
		if r.Error == gorm.ErrRecordNotFound {
			return errors.New("记录不存在")
		} else {
			return r.Error
		}
	}
	//校验是否存在

	//更新
	if r := db.Updates(po); r.Error != nil {
		return r.Error
	}

	this.sc.AuthCheck.LoadPolicy()
	return nil
}
