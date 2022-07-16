package handler

import (
	"github.com/gin-gonic/gin"
    "gs/api/hd"
    "{{.Module}}/internal/serctx"
    "{{.Module}}/internal/app/{{.AppPackage}}/{{.ModelPackage}}"
	"{{.Module}}/internal/router/irouter"	
	"errors"
	"gorm.io/gorm"
)




type {{.AppName}}Put struct {
    ctx    *gin.Context
	serctx *serctx.ServerContext
}

func New{{.AppName}}Put (ctx *gin.Context,serCtx *serctx.ServerContext) irouter.IHandler{
	return &{{.AppName}}Put{ctx, serCtx}
}


func (this *{{.AppName}}Put) Do() error {
	var err error
	id, err := hd.GetId(this.ctx)
	if err != nil {
		return err
	}
	po := &{{.ModelPackage}}.{{.ModelName}}{}
	err = hd.Bind(this.ctx, po)
	if err != nil {
		return err
	}
	po.ID = id
	err = this.Put(po)
	if err != nil {
		return err
	}
	hd.RepOk(this.ctx)
	return nil
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
	if r := db.Select("xx","xx").Updates(po); r.Error != nil {
		return r.Error
	}
	return nil
}
