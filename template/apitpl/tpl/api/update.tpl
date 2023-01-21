package handler

import (
	"github.com/gin-gonic/gin"
    "{{.Host}}/api/hd"
    "{{.Module}}/internal/ctx"
    "{{.Module}}/internal/api/{{.ApiPackage}}/{{.ModelPackage}}"
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


func (this *{{.ApiName}}Update) Do() error {
	var err error
	id, err := this.GetId()
	if err != nil {
		return err
	}
	po := &{{.ModelPackage}}.{{.ModelName}}{}
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

func (this *{{.ApiName}}Update) Update(po *{{.ModelPackage}}.{{.ModelName}}) error {
    db := this.sc.Db
	tmpPo := &{{.ModelPackage}}.{{.ModelName}}{}
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
