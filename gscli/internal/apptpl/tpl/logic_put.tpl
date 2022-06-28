package logic

import (
	"errors"
    "{{.Module}}/internal/serctx"
    "github.com/gin-gonic/gin"
    "{{.Module}}/internal/app/{{.AppPackage}}/{{.ModelPackage}}"
    "gorm.io/gorm"
)

type {{.AppName}}Put struct {
    ctx    *gin.Context
	serctx *serctx.ServerContext
}

func New{{.AppName}}Put(ctx *gin.Context,serCtx *serctx.ServerContext) *{{.AppName}}Put {
	return &{{.AppName}}Put{ctx, serCtx}
}

func (this *{{.AppName}}Put) Put(po *{{.ModelPackage}}.{{.ModelName}}) error {
    db := this.serctx.Db
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
	if r := db.Select([]string{"xx","xx"}).Updates(po); r.Error != nil {
		return r.Error
	}
	return nil
}
