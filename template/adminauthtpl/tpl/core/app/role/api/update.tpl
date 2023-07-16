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

type RoleUpdate struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewRoleUpdate(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &RoleUpdate{hd.NewHd(c), c, sc}
}

//	@tags		角色管理
//	@summary	修改角色
//	@x-group	{"key":"role","inorder":3}
//	@router		/api/role/:id [put]
//	@param		id				path		int						true	" "	extensions(x-name=用户ID,x-value=1)
//	@param		Authorization	header		string					true	" "	extensions(x-name=鉴权,x-value=[TOKEN])
//	@param		root			body		rolemodel.RoleUpdate	true	" "
//
//	@success	200				{object}	string					"ok"
func (this *RoleUpdate) Do() error {
	var err error
	id, err := this.GetId()
	if err != nil {
		return err
	}
	po := &rolemodel.RoleUpdate{}
	err = this.Bind(po)
	if err != nil {
		return err
	}
	po.ID = id
	err = this.Update(po)
	if err != nil {
		return err
	}
	this.RepOk()
	return nil
}

func (this *RoleUpdate) Update(po *rolemodel.RoleUpdate) error {
	db := this.sc.Db
	tmpPo := &rolemodel.RolePo{}
	if r := db.Model(tmpPo).Take(tmpPo); r.Error != nil {
		if r.Error == gorm.ErrRecordNotFound {
			return errors.New("记录不存在")
		} else {
			return r.Error
		}
	}

	//更新
	if r := db.Updates(po); r.Error != nil {
		return r.Error
	}

	if tmpPo.Status != po.Status {
		this.sc.AuthCheck.LoadPolicy()
	}

	return nil
}
