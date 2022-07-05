package logic

import (
	"errors"
    "{{.Module}}/internal/serctx"
    "github.com/gin-gonic/gin"
    "{{.Module}}/internal/app/{{.AppPackage}}/{{.ModelPackage}}"
    "gorm.io/gorm"
)

type {{.AppName}}Del struct {
    ctx    *gin.Context
	serctx *serctx.ServerContext
}

func New{{.AppName}}Del(ctx *gin.Context,serCtx *serctx.ServerContext) *{{.AppName}}Del {
	return &{{.AppName}}Del{ctx, serCtx}
}

func (this *{{.AppName}}Del) Delete(id int64) error {
	db := this.serctx.Db
	po := &{{.ModelPackage}}.{{.ModelName}}{}
	po.ID = id
	if r := db.Take(po); r.Error != nil {
		if r.Error == gorm.ErrRecordNotFound {
			return errors.New("")
		} else {
			return r.Error
		}
	}
	if r := db.Delete(po); r.Error != nil {
		return r.Error
	}
	return nil
}
