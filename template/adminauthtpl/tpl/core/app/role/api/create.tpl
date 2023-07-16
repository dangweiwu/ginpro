package api

import (
	"{{.Module}}/internal/app/role/rolemodel"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/router/irouter"
	"errors"
	"github.com/gin-gonic/gin"
	"{{.Host}}/api/hd"
)

type RoleCreate struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

//	@tags		角色管理
//	@summary	创建角色
//	@x-group	{"key":"role","name":"角色管理","order":4,"desc":"","inorder":1}
//	@param		Authorization	header	string	true	" "	extensions(x-name=鉴权,x-value=[TOKEN])
//	@router		/api/role [post]
//	@param		Authorization	header		string				true	"token"
//	@param		root			body		rolemodel.RoleForm	true	" "
//	@success	200				{string}	string				"{data:'ok'}"
func NewRoleCreate(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &RoleCreate{hd.NewHd(c), c, sc}
}

func (this *RoleCreate) Do() error {
	//数据源
	po := &rolemodel.RoleForm{}
	err := this.Bind(po)
	if err != nil {
		return err
	}

	err = this.Create(po)
	if err != nil {
		return err
	}
	this.RepOk()
	return nil
}

func (this *RoleCreate) Create(po *rolemodel.RoleForm) error {
	db := this.sc.Db
	//验证是否已创建 或者其他检查
	tmpPo := &rolemodel.RolePo{}
	if r := db.Model(tmpPo).Where("code = ?", po.Code).Take(tmpPo); r.Error == nil {
		return errors.New("角色编码已存在")
	}

	if r := db.Create(po); r.Error != nil {
		return r.Error
	}
	return nil
}
