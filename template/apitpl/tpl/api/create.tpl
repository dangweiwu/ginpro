package api

import (
	"github.com/gin-gonic/gin"
    "{{.Host}}/api/hd"
    "{{.Module}}/internal/ctx"
    "{{.Module}}/internal/app/{{.ApiPackage}}/{{.ModelPackage}}"
	"{{.Module}}/internal/router/irouter"	
)

type {{.ApiName}}Create struct {
	*hd.Hd
    ctx *gin.Context
	sc  *ctx.ServerContext
}

// @x-group		{"key":"{{.ApiName}}","name":"","order":1,"desc":"","inorder":1}
//	@summary	创建{{.ApiName}}
//	@router		/api/{{.RouterUrl}} [post]
//  @param      Authorization header   string                 true " " extensions(x-name=鉴权,x-value=[TOKEN])
//	@param		root			body		{{.ModelPackage}}.{{.ModelName}}Form		true	" "
//	@success	200				{string} string	 "{data:'ok'}"
func New{{.ApiName}}Create(c *gin.Context,sc *ctx.ServerContext) irouter.IHandler{
	return &{{.ApiName}}Create{hd.NewHd(c),c, sc}
}

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
