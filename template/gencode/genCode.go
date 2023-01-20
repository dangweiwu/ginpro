package gencode

import (
	"gs/pkg/utils"
	"io/fs"
	"os"
	"path"
)

var chmod fs.FileMode = 755

// 生成模板
type GenCode struct {
	fileItem []FileItem
	root     string
	module   ModuleValue
}

func NewGenCode(root string, module ModuleValue) *GenCode {
	a := &GenCode{root: root, module: module}
	a.fileItem = []FileItem{}
	return a
}

func (this *GenCode) Add(item FileItem) {
	this.fileItem = append(this.fileItem, item)
}

func (this *GenCode) SetFileItem(s []FileItem) {
	this.fileItem = s
}
func (this *GenCode) Gen() error {
	for _, v := range this.fileItem {
		v.Dir = append([]string{this.root}, v.Dir...)
		pt := path.Join(v.Dir...)
		if err := os.MkdirAll(pt, chmod); err != nil {
			return err
		}

		codefile := path.Join(pt, v.FileName)
		if err := utils.GenTpl(v.Tpl, this.module, codefile); err != nil {
			return err
		}
	}
	return nil
}
