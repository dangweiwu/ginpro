package {{.ModelPackage}}

import(
	"{{.Host}}/pkg/dbtype"
)

type {{.ModelName}} struct {
	dbtype.Base
	//Demo     string      +` + "`+gorm:\"size:100;not null;default:'';comment:demo\" binding:\"max=100\"`" + `
}

func ({{.ModelName}}) TableName() string {
	return "{{.TableName}}"
}