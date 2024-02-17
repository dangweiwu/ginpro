package {{.ModelPackage}}

import(
	"{{.Host}}/pkg/dbtype"
)

// @doc | {{.ModelPackage}}.{{.ModelName}}Form
type {{.ModelName}}Form struct {
	dbtype.BaseForm
}

func ({{.ModelName}}Form) TableName() string {
	return "{{.TableName}}"
}