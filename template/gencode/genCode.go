package gencode

import (
	"github.com/pkg/errors"
	"gs/pkg/utils"
	"io/fs"
	"os"
	"path"
	"text/template"
)

var chmod fs.FileMode = 755

// 生成模板
type GenCode struct {
	fileItem []FileItem //需要模板的
	CopyFile []CopyFile //直接copy的
	root     string
	//module   ModuleValue
	module interface{}
	tp     string //生成类型 html other
	funcs  template.FuncMap
}

func NewGenCode(root string, module interface{}) *GenCode {
	a := &GenCode{root: root, module: module}
	a.fileItem = []FileItem{}
	a.funcs = template.FuncMap{}
	return a
}

func (this *GenCode) SetHtmlType() {
	this.tp = "html"
}

func (this *GenCode) AddFunc(name string, f any) {
	this.funcs[name] = f
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

		if this.tp == "html" {
			if err := utils.GenHtml(v.Tpl, this.module, codefile, this.funcs); err != nil {
				return errors.WithMessage(err, codefile)
			}
		} else {
			if err := utils.GenTpl(v.Tpl, this.module, codefile); err != nil {
				return errors.WithMessage(err, codefile)
			}
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
