package gencode

type ModuleValue struct {
	Module string //当前项目名
	Host   string //主项目地址
}

type FileItem struct {
	FileName string
	Dir      []string
	Tpl      string
}
