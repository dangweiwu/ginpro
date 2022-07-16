package handler

import (
    "github.com/gin-gonic/gin"
    "gorm.io/gorm"
	"gs/api/hd"
	"errors"
    "{{.Module}}/internal/app/{{.AppPackage}}/{{.ModelPackage}}"
	"{{.Module}}/internal/serctx"
	"{{.Module}}/internal/router/irouter"
)



type {{.AppName}}Del struct {
    ctx    *gin.Context
	serctx *serctx.ServerContext
}

func New{{.AppName}}Del (ctx *gin.Context,serCtx *serctx.ServerContext) irouter.IHandler {
	return &{{.AppName}}Del{ctx, serCtx}
}

func (this *{{.AppName}}Del) Do() error {
	var err error
	id, err := hd.GetId(this.ctx)
	if err != nil {
		return err
	}
	if err := this.Delete(id); err != nil {
		return err
	} else {
		hd.RepOk(this.ctx)
		return nil
	}
}

func (this *{{.AppName}}Del) Delete(id int64) error {
	db := this.serctx.Db
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
