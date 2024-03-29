package option

import (
	"errors"
	"fmt"
	"github.com/dangweiwu/ginpro/tmpl/adminauthtpl"
)

type AdminAuthServer struct {
}

func (this *AdminAuthServer) Usage() string {
	return `project-name

  生成admin auth sys server框架`
	//1: mysql模块
	//2: redis模块
	//3: 登陆及jwt
	//4: 适配es的日志系统
	//5: api指标监控Prometheus
	//6: admin user 模块
	//7: auth role 模块`
}

func (this *AdminAuthServer) Execute(args []string) error {
	if len(args) == 0 {
		return errors.New("缺少项目名称")
	}
	name := args[0]
	err := adminauthtpl.GenCode(name)
	if err != nil {
		return err
	}

	fmt.Println("admin项目初始化完成")
	fmt.Println()
	fmt.Println("please run:")
	fmt.Println()
	fmt.Printf("cd %s &&\n", args[0])
	fmt.Printf("go mod init %s && \n", args[0])
	fmt.Printf("go mod tidy && \n")
	fmt.Printf("go work use .")
	fmt.Println()
	return nil
}
