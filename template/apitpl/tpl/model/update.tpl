package {{.ModelPackage}}

import(
	"{{.Host}}/pkg/dbtype"
)


// @doc | {{.ModelPackage}}.{{.ModelName}}UpdateForm
type {{.ModelName}}UpdateForm struct {
	dbtype.BaseForm
}

func ({{.ModelName}}UpdateForm) TableName() string {
	return "{{.TableName}}"
}

