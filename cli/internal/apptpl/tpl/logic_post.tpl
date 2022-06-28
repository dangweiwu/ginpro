package logic

import (
	//"errors"
    "{{.Module}}/internal/serctx"
    "github.com/gin-gonic/gin"
    "{{.Module}}/internal/app/{{.AppPackage}}/{{.ModelPackage}}"
)


type {{.AppName}}Post struct {
    ctx    *gin.Context
	serctx *serctx.ServerContext
}

func New{{.AppName}}Post(ctx *gin.Context,serCtx *serctx.ServerContext) *{{.AppName}}Post {
	return &{{.AppName}}Post{ctx, serCtx}
}


func (this {{.AppName}}Post) Post(po *{{.ModelPackage}}.{{.ModelName}}) error {
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
