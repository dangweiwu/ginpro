package gencode

const (
	Host = "gs"
)

type ModuleValue struct {
	Module       string //当前项目名
	Host         string //主项目地址
	ApiName      string //api name
	ApiPackage   string //api package
	ModelPackage string //api mod package,first lower
	ModelName    string //model name,has po,first upper
	TableName    string
	RouterType   string
	RouterUrl    string
}

type FileItem struct {
	FileName string
	Dir      []string
	Tpl      string
}

type CopyFile struct {
	FileName string
	Dir      []string
	Tpl      string
}
