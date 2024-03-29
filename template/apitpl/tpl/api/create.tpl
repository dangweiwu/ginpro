package api

import (
	"github.com/gin-gonic/gin"
    "{{.Module}}/internal/pkg/api/hd"
    "{{.Module}}/internal/ctx"
    "{{.Module}}/internal/app/{{.ApiPackage}}/{{.ModelPackage}}"
	"{{.Module}}/internal/router/irouter"	
)

type {{.ApiName}}Create struct {
	*hd.Hd
    ctx *gin.Context
	appctx  *ctx.AppContext
}


func New{{.ApiName}}Create(c *gin.Context,appctx *ctx.AppContext) irouter.IHandler{
	return &{{.ApiName}}Create{hd.NewHd(c),c, appctx}
}

// Do
// @api    | {{.ApiName}} | 1 | 创建{{.ApiName}}
// @path   | /api/{{.RouterUrl}}
// @method | POST
// @header |n Authorization |d token |t string |c 鉴权
// @form   | {{.ModelPackage}}.{{.ModelName}}Form
// @tbtitle  | 200 Response
// @tbrow    |n data |e ok |c 成功 |t string
func (this *{{.ApiName}}Create) Do() error {
    //数据源
	po := &{{.ModelPackage}}.{{.ModelName}}Form{}
	err := this.Bind(po)
	if err != nil {
		return err
	}

	err = this.Create(po)
	if err != nil {
		return err
	}
	this.RepOk()
	return nil
}

func (this *{{.ApiName}}Create) Create(po *{{.ModelPackage}}.{{.ModelName}}Form) error {
	db := this.appctx.Db
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
