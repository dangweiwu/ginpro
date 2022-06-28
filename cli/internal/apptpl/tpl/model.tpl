package {{.ModelPackage}}

import(
	"gs/pkg/dbtype"
)

type {{.ctx *gin.Context,serCtx *serctx.ServerContext}} struct {
	dbtype.Base
	//Demo     string      +` + "`+gorm:\"size:100;not null;default:'';comment:demo\" binding:\"max=100\"`" + `
}

func ({{.ModelName}}) TableName() string {
	return "{{.TableName}}"
}