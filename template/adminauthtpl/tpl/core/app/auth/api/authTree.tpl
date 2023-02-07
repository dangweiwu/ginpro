package api

import (
	"{{.Module}}/internal/app/auth/authmodel"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/router/irouter"
	"github.com/gin-gonic/gin"
	"{{.Host}}/api/hd"
)

/*
auth 树形结构
	{children:'children', title:'title', key:'key' }
*/

type AuthTree struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewAuthTree(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &AuthTree{hd.NewHd(c), c, sc}
}

//	@tags		权限管理
//	@summary	树形数据
//	@router		/api/auth/tree [get]
//	@success	200	{object}	authmodel.AuthTree
func (this *AuthTree) Do() error {
	po := &authmodel.AuthTree{}
	if err := this.sc.Db.Model(po).Where("parent_id=0").Preload("Children").Order("order_num").Find(po).Error; err != nil {
		return err
	}

	this.Rep(hd.Response{po})
	return nil
}
