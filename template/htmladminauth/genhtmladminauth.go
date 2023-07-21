package htmladminauth

import (
	"embed"
	"gs/pkg/utils"
)

//go:embed tpl/* tpl/.*
var F embed.FS

type HtmlAdminAuth struct {
	name string
}

func NewHtmlAdminAuth(name string) *HtmlAdminAuth {
	return &HtmlAdminAuth{name: name}
}

func (this *HtmlAdminAuth) Gen() error {
	//压缩文件

	r := utils.NewCopyFile(this.name, F)
	return r.Do()

}

func GenHtmlAdminAuth(name string) error {
	return NewHtmlAdminAuth(name).Gen()
}
