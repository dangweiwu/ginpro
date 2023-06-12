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

type FormItem struct {
	Name string
	Key  string
	Type string //string int
	//Radio map[string]string //radio value valuename
	Rule []string //rule type name
}

// 生成html使用
type HtmlValue struct {
	Name      string
	View      []FormItem
	QueryRule []FormItem //query rule key name
	Create    []FormItem
	Update    []FormItem
}
