package api

import (
	"github.com/gin-gonic/gin"
    "{{.Host}}/api/hd"
    "{{.Module}}/internal/ctx"
    "{{.Module}}/internal/app/{{.ApiPackage}}/{{.ModelPackage}}"
	"{{.Module}}/internal/router/irouter"	
	"errors"
	"gorm.io/gorm"
)

type {{.ApiName}}Update struct {
	*hd.Hd
    ctx *gin.Context
	sc  *ctx.ServerContext
}

func New{{.ApiName}}Update (c *gin.Context,sc *ctx.ServerContext) irouter.IHandler{
	return &{{.ApiName}}Update{hd.NewHd(c),c, sc}
}


// @tags		主题{{.ApiName}}
// @summary	    修改{{.ApiName}}
// @router		/api/{{.RouterUrl}}/:id [put]
// @param		id				path		int							true	"用户ID"
// @param		Authorization	header		string						true	"token"
// @param		root			body		{{.ModelPackage}}.{{.ModelName}}Form	true	"修改信息"
// @success	200				{object}	hd.Response{data=string}	"ok"
func (this *{{.ApiName}}Update) Do() error {
	var err error
	id, err := this.GetId()
	if err != nil {
		return err
	}
	po := &{{.ModelPackage}}.{{.ModelName}}Form{}
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

func (this *{{.ApiName}}Update) Update(po *{{.ModelPackage}}.{{.ModelName}}Form) error {
    db := this.sc.Db
	tmpPo := &{{.ModelPackage}}.{{.ModelName}}Form{}
	if r := db.Model(tmpPo).Take(tmpPo); r.Error != nil {
		if r.Error == gorm.ErrRecordNotFound {
			return errors.New("记录不存在")
		} else {
			return r.Error
		}
	}
    //其他校验

    //更新
	if r := db.Select("xx","xx").Updates(po); r.Error != nil {
		return r.Error
	}
	return nil
}
