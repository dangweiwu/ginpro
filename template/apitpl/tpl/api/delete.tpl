package api

import (
    "github.com/gin-gonic/gin"
    "gorm.io/gorm"
    "errors"
    "{{.Module}}/internal/pkg/api/hd"
    "{{.Module}}/internal/app/{{.ApiPackage}}/{{.ModelPackage}}"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/router/irouter"
)


type {{.ApiName}}Del struct {
	*hd.Hd
    ctx *gin.Context
	appctx  *ctx.AppContext
}

func New{{.ApiName}}Del (c *gin.Context,appctx *ctx.AppContext) irouter.IHandler {
	return &{{.ApiName}}Del{hd.NewHd(c),c, appctx}
}

// Do
// @api | {{.ApiName}} | 4 | 删除用户
// @path | /api/{{.RouterUrl}}/:id
// @method | DELETE
// @header 	|n Authorization |d token |e tokenstring |c 鉴权 |t string
// @urlparam |n id |d  |v required |t int    |e 1
// @tbtitle  | 200 Response
// @tbrow    |n data |e ok |c 成功 |t type
// @response | hd.ErrResponse | 500 RESPONSE
// @tbtitle  | msg 数据
// @tbrow    |n msg |e 记录不存在
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
	db := this.appctx.Db
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
