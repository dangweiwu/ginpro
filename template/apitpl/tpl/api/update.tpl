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

// @x-group		{"key":"{{.ApiName}}","inorder":2}
// @summary	    修改{{.ApiName}}
// @router		/api/{{.RouterUrl}}/:id [put]
// @param   Authorization header   string                   true " " extensions(x-name=鉴权,x-value=[TOKEN])
// @param   id            path     int                      true " "  extensions(x-name=用户ID,x-value=1)
// @param		root			body		{{.ModelPackage}}.{{.ModelName}}UpdateForm	true	" "
// @success	200				{string}	string	"{data:'ok'}"
func (this *{{.ApiName}}Update) Do() error {
	var err error
	id, err := this.GetId()
	if err != nil {
		return err
	}
	form := &{{.ModelPackage}}.{{.ModelName}}UpdateForm{}
	err = this.Bind(form)
	if err != nil {
		return err
	}
	form.ID = id
	err = this.Update(form)
	if err != nil {
		return err
	}
	this.RepOk()
	return nil
}

func (this *{{.ApiName}}Update) Update(form *{{.ModelPackage}}.{{.ModelName}}UpdateForm) error {
    db := this.sc.Db
	tmpForm := &{{.ModelPackage}}.{{.ModelName}}UpdateForm{}
	if r := db.Model(tmpForm).Take(tmpForm); r.Error != nil {
		if r.Error == gorm.ErrRecordNotFound {
			return errors.New("记录不存在")
		} else {
			return r.Error
		}
	}
    //其他校验

    //更新
	if r := db.Select("*").Updates(form); r.Error != nil {
		return r.Error
	}
	return nil
}
