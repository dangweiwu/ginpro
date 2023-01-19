package option

import (
	"errors"
	"fmt"
	"gs/template/servertpl"
	"os"
)

// 生成 server
type ServerOption struct {
}

func (this *ServerOption) Usage() string {
	return `project-name

  生成基础服务框架`
}

func (this *ServerOption) Execute(args []string) error {
	if len(args) == 0 {
		return errors.New("缺少项目名称")
	}

	obj, err := servertpl.NewGenFramework(args[0])
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	if err := obj.Do(); err != nil {
		return err
	}
	fmt.Println(args[0] + "已生成")
	fmt.Println()
	fmt.Println("please run:")
	fmt.Println()

	fmt.Printf(`cd ./%s &&
go mod init %s && 
go mod tidy`, args[0], args[0])

	return nil
}
