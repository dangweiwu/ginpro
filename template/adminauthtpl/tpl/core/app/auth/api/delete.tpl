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
//	@x-group	{"key":"auth","inorder":2}
//	@router		/api/auth/:id [delete]
//	@param		Authorization	header		string	true	" "	extensions(x-name=鉴权,x-value=[TOKEN])
//	@param		id				path		int		true	" "	extensions(x-name=用户ID,x-value=1)
//	@success	200				{string}	string	"{data:'ok'}"
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
	ct := int64(0)
	if r := db.Model(&authmodel.AuthPo{}).Where("parent_id=?", id).Count(&ct); r.Error != nil {
		return r.Error
	}

	if ct != 0 {
		return errors.New("该权限下包含其他权限，禁止删除！")
	}

	if r := db.Delete(po); r.Error != nil {
		return r.Error
	}
	return nil
}