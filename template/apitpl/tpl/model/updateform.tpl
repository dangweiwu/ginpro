package {{.ModelPackage}}

import(
	"{{.Host}}/pkg/dbtype"
)

type {{.ModelName}}UpdateForm struct {
	dbtype.BaseForm
	//Demo     string      +` + "`+gorm:\"size:100;not null;default:'';comment:demo\" binding:\"max=100\"`" + `
}

func ({{.ModelName}}UpdateForm) TableName() string {
	return "{{.TableName}}"
}

