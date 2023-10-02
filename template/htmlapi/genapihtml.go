package htmlapi

import (
	_ "embed"
	"github.com/dangweiwu/ginpro/template/gencode"
	"os"
	"strings"
)

var (
	//go:embed tpl/index.vue
	Indexhtml string

	//go:embed tpl/create.vue
	Createhtml string

	//go:embed tpl/update.vue
	Updatehtml string

	//go:embed tpl/api.js
	ApiJs string
)

type ApiHtml struct {
	code *gencode.GenCode
	name string
}

func NewApiHtml(name string) (*ApiHtml, error) {
	wd, err := os.Getwd()
	if err != nil {
		return nil, err
	}
	obj := gencode.NewModelObj(wd)
	if err := obj.GetFiles(); err != nil {
		return nil, err
	}
	if err := obj.ParseData(); err != nil {
		return nil, err
	}
	val := obj.GetData()
	val.Name = name

	code := gencode.NewGenCode(wd, val)
	code.SetHtmlType()
	code.AddFunc("ListHas", tplListHasKey)
	code.AddFunc("IsNumber", tplIsNumber)
	code.AddFunc("UpFirst", tplUpFirst)
	return &ApiHtml{code: code, name: name}, nil

}

func (this *ApiHtml) InitFile() error {
	fileItems := []gencode.FileItem{
		{"index.vue", []string{this.name}, Indexhtml},
		{"create.vue", []string{this.name}, Createhtml},
		{"update.vue", []string{this.name}, Updatehtml},
		{this.name + ".ts", []string{this.name, "api"}, ApiJs},
	}
	this.code.SetFileItem(fileItems)
	return nil
}
func (this *ApiHtml) GenFile() error {

	return this.code.Gen()
}

func GenCode(name string) error {
	a, err := NewApiHtml(name)
	if err != nil {
		return err
	}
	if err := a.InitFile(); err != nil {
		return err
	}
	return a.GenFile()
}

func tplListHasKey(d []string, name string) bool {
	if len(d) == 0 {
		return false
	}
	for _, v := range d {
		if v == name {
			return true
		}
	}
	return false
}

func tplIsNumber(tp string) bool {
	if tp == "int" || tp == "int8" || tp == "int16" || tp == "int32" {
		return true
	} else {
		return false
	}
}

func tplUpFirst(s string) string {
	if len(s) == 0 {
		return ""
	}
	if len(s) == 1 {
		return strings.ToUpper(string(s[0]))
	}
	return strings.ToUpper(string(s[0])) + s[1:len(s)]
}
