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
	appctx  *ctx.AppContext
}

func New{{.ApiName}}Update (c *gin.Context,appctx *ctx.AppContext) irouter.IHandler{
	return &{{.ApiName}}Update{hd.NewHd(c),c, appctx}
}

// Do
// @api    | {{.ApiName}} | 2 | 更新 {{.ApiName}}
// @path 	| /api/{{.RouterUrl}}/:id
// @method 	| PUT
// @urlparam |n id |d 用户ID |v required |t int    |e 1
// @header   |n Authorization |d token  |t string |c 鉴权
// @form     | {.ModelPackage}}.{{.ModelName}}UpdateForm
// @tbtitle  | 200 Response
// @tbrow    |n data |e ok |c 成功 |t string
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
    db := this.appctx.Db
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
