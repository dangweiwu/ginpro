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
	fileItem []FileItem //需要模板的
	CopyFile []CopyFile //直接copy的
	root     string
	module   ModuleValue
}

func NewGenCode(root string, module ModuleValue) *GenCode {
	a := &GenCode{root: root, module: module}
	a.fileItem = []FileItem{}
	return a
}

func (this *GenCode) SetFileItem(s []FileItem) {
	this.fileItem = s
}

func (this *GenCode) SetCopyFile(s []CopyFile) {
	this.CopyFile = s
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

	for _, v := range this.CopyFile {
		v.Dir = append([]string{this.root}, v.Dir...)
		pt := path.Join(v.Dir...)
		if err := os.MkdirAll(pt, chmod); err != nil {
			return err
		}

		codefile := path.Join(pt, v.FileName)
		dst, err := os.OpenFile(codefile, os.O_WRONLY|os.O_CREATE, 0644)
		if err != nil {
			return err
		}
		if _, err = dst.Write([]byte(v.Tpl)); err != nil {
			dst.Close()
			return err
		}
		if err = dst.Close(); err != nil {
			return err
		}
	}

	return nil
}
