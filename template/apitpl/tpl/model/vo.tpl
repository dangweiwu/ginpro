package {{.ModelPackage}}

import(
	"{{.Host}}/pkg/dbtype"
)


// @doc | {{.ModelPackage}}.{{.ModelName}}Vo
type {{.ModelName}}Vo struct {
	dbtype.Base
}

func ({{.ModelName}}Vo) TableName() string {
	return "{{.TableName}}"
}

var QueryRule = map[string]string{
	//	key:"like"  or ""
}
