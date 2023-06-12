package utils

import (
	"fmt"
	"os"
	"text/template"
)

func GenTpl(tpl string, value interface{}, file string) error {
	tpl_obj, err := template.New("tpl").Parse(tpl)
	if err != nil {
		return err
	}
	f, err := os.OpenFile(file, os.O_CREATE|os.O_WRONLY, 755)
	if err != nil {
		return err
	}
	//渲染输出
	if err := tpl_obj.Execute(f, value); err != nil {
		fmt.Println("模板渲染失败:", file)
		fmt.Println(tpl)
		fmt.Println(value)
		return err
	}
	return nil
}

func GenHtml(tpl string, value interface{}, file string, funcs template.FuncMap) error {
	tpl_obj := template.New("tpl").Delims("[[", "]]")
	tpl_obj.Funcs(funcs)

	tpl_obj, err := tpl_obj.Parse(tpl)
	if err != nil {
		return err
	}

	f, err := os.OpenFile(file, os.O_CREATE|os.O_WRONLY, 755)
	if err != nil {
		return err
	}
	//渲染输出
	if err := tpl_obj.Execute(f, value); err != nil {
		fmt.Println("模板渲染失败:", file)
		fmt.Println(tpl)
		fmt.Println(value)
		return err
	}
	return nil
}
