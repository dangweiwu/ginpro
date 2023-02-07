package api

import (
	"{{.Module}}/internal/app/auth/authmodel"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/router/irouter"
	"errors"
	"github.com/gin-gonic/gin"
	"{{.Host}}/api/hd"
)

type AuthCreate struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewAuthCreate(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &AuthCreate{hd.NewHd(c), c, sc}
}

//	@tags		权限管理
//	@summary	创建权限
//	@router		/api/auth [post]
//	@param		Authorization	header		string						true	"token"
//	@param		root			body		authmodel.AuthPo			true	"权限"
//	@success	200				{object}	hd.Response{data=string}	"ok"
func (this *AuthCreate) Do() error {
	//数据源
	po := &authmodel.AuthForm{}
	err := this.Bind(po)
	if err != nil {
		return err
	}

	err = this.Create(po)
	if err != nil {
		return err
	}

	this.sc.AuthCheck.LoadPolicy()
	this.RepOk()
	return nil
}

func (this *AuthCreate) Create(po *authmodel.AuthForm) error {
	db := this.sc.Db
	//验证是否已创建 或者其他检查
	tmpPo := &authmodel.AuthPo{}
	if r := db.Model(po).Where("code = ?", po.Code).Take(tmpPo); r.Error == nil {
		return errors.New("权限编码已存在")
	}

	if r := db.Create(po); r.Error != nil {
		return r.Error
	}
	return nil
}
