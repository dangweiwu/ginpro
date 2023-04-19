package {{.ModelPackage}}

import(
	"{{.Host}}/pkg/dbtype"
)

type {{.ModelName}}Vo struct {
	dbtype.Base
	//Demo     string      +` + "`+gorm:\"size:100;not null;default:'';comment:demo\" binding:\"max=100\"`" + `
}

func ({{.ModelName}}Vo) TableName() string {
	return "{{.TableName}}"
}