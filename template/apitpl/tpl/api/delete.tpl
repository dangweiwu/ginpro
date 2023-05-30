package api

import (
    "github.com/gin-gonic/gin"
    "gorm.io/gorm"
	"{{.Host}}/api/hd"
	"errors"
    "{{.Module}}/internal/app/{{.ApiPackage}}/{{.ModelPackage}}"
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

//  @x-group    {"key":"{{.ApiName}}","inorder":3}
//	@summary	删除{{.ApiName}}
//	@router		/api/{{.RouterUrl}}/:id [delete]
//  @param   Authorization header   string                   true " " extensions(x-name=鉴权,x-value=[TOKEN])
//  @param   id            path     int                      true " "  extensions(x-name=用户ID,x-value=1)
//  @success	200		{string} string	 "{data:'ok'}"
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
	po := &{{.ModelPackage}}.{{.ModelName}}Po{}
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
