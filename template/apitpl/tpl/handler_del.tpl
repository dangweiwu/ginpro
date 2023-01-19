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
	*hd.Hd
    ctx *gin.Context
	sc  *serctx.ServerContext
}

func New{{.AppName}}Del (ctx *gin.Context,sc *serctx.ServerContext) irouter.IHandler {
	return &{{.AppName}}Del{hd.NewHd(ctx),ctx, sc}
}

func (this *{{.AppName}}Del) Do() error {
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

func (this *{{.AppName}}Del) Delete(id int64) error {
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
