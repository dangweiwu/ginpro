package {{.ModelPackage}}

import(
	"{{.Host}}/pkg/dbtype"
)

type {{.ModelName}}Form struct {
	dbtype.BaseForm
	//Demo     string      +` + "`+gorm:\"size:100;not null;default:'';comment:demo\" binding:\"max=100\"`" + `
}

func ({{.ModelName}}Form) TableName() string {
	return "{{.TableName}}"
}