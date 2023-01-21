package handler

import (
    "github.com/gin-gonic/gin"
    "gorm.io/gorm"
	"{{.Host}}/api/hd"
	"errors"
    "{{.Module}}/internal/api/{{.ApiPackage}}/{{.ModelPackage}}"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/router/irouter"
)


type {{.ApiName}}Del struct {
	*hd.Hd
    ctx *gin.Context
	sc  *ctx.ServerContext
}

func New{{.ApiName}}Del (c *gin.Context,sc *ctx.ServerContext) irouter.IHandler {
	return &{{.ApiName}}Del{hd.NewHd(c),c, sc}
}

func (this *{{.ApiName}}Del) Do() error {
	var err error
	id, err := this.GetId()
	if err != nil {
		return err
	}
	if err := this.Delete(id); err != nil {
		return err
	} else {
		this.RepOk()
		return nil
	}
}

func (this *{{.ApiName}}Del) Delete(id int64) error {
	db := this.sc.Db
	po := &{{.ModelPackage}}.{{.ModelName}}{}
	po.ID = id
	if r := db.Take(po); r.Error != nil {
		if r.Error == gorm.ErrRecordNotFound {
			return errors.New("记录不存在")
		} else {
			return r.Error
		}
	}
	if r := db.Delete(po); r.Error != nil {
		return r.Error
	}
	return nil
}
