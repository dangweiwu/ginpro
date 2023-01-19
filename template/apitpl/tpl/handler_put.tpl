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
	*hd.Hd
    ctx    *gin.Context
	sc *serctx.ServerContext
}

func New{{.AppName}}Put (ctx *gin.Context,sc *serctx.ServerContext) irouter.IHandler{
	return &{{.AppName}}Put{hd.NewHd(ctx),ctx, sc}
}


func (this *{{.AppName}}Put) Do() error {
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
	err = this.Put(po)
	if err != nil {
		return err
	}
	this.RepOk()
	return nil
}

func (this *{{.AppName}}Put) Put(po *{{.ModelPackage}}.{{.ModelName}}) error {
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
