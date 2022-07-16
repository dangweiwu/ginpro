package handler

import (
	"github.com/gin-gonic/gin"
    "gs/api/hd"
	"errors"
    "{{.Module}}/internal/serctx"
    "{{.Module}}/internal/app/{{.AppPackage}}/{{.ModelPackage}}"
	"{{.Module}}/internal/router/irouter"	
)

type {{.AppName}}Post struct {
    ctx    *gin.Context
	serctx *serctx.ServerContext
}

func New{{.AppName}}Post(ctx *gin.Context,serCtx *serctx.ServerContext) irouter.IHandler{
	return &{{.AppName}}Post{ctx, serCtx}
}

func (this *{{.AppName}}Post) Do() error {
    //数据源
	po := &{{.ModelPackage}}.{{.ModelName}}{}
	err := hd.Bind(this.ctx, po)
	if err != nil {
		return err
	}

	err = this.Post(po)
	if err != nil {
		return err
	}
	hd.RepOk(this.ctx)
	return nil
}

func (this *{{.AppName}}Post) Post(po *{{.ModelPackage}}.{{.ModelName}}) error {
	db := this.serctx.Db
	//验证是否已创建 或者其他检查
	//tmpPo := &{{.ModelPackage}}.{{.ModelName}}{}
	//if r := db.Model(po).Where("name = ?", po.XXX).Take(tmpPo); r.Error == nil {
	//	return errors.New("记录已存在")
	//}

	if r := db.Create(po); r.Error != nil {
		return r.Error
	}
	return nil
}
