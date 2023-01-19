package handler

import (
	"github.com/gin-gonic/gin"
    "gs/api/hd"
    "{{.Module}}/internal/serctx"
    "{{.Module}}/internal/app/{{.AppPackage}}/{{.ModelPackage}}"
	"{{.Module}}/internal/router/irouter"	
)

type {{.AppName}}Post struct {
	*hd.Hd
    ctx *gin.Context
	sc  *serctx.ServerContext
}

func New{{.AppName}}Post(ctx *gin.Context,sc *serctx.ServerContext) irouter.IHandler{
	return &{{.AppName}}Post{hd.NewHd(ctx),ctx, sc}
}

func (this *{{.AppName}}Post) Do() error {
    //数据源
	po := &{{.ModelPackage}}.{{.ModelName}}{}
	err := this.Bind(po)
	if err != nil {
		return err
	}

	err = this.Post(po)
	if err != nil {
		return err
	}
	this.RepOk()
	return nil
}

func (this *{{.AppName}}Post) Post(po *{{.ModelPackage}}.{{.ModelName}}) error {
	db := this.sc.Db
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
