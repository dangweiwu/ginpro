package apptpl

import (
	"fmt"
	"gs/gscli/internal/apptpl/tpl"
	"gs/pkg/utils"
	"os"
	"path"
	"strings"

	"github.com/pkg/errors"
)

const (
	HandlerName = "handler"
	LogicName   = "logic"
)

type ApiApp struct {
	root string
	cfg  tpl.AppTplConfig
}

func NewApiApp(cfg tpl.AppTplConfig) (*ApiApp, error) {
	wd, err := os.Getwd()
	if err != nil {
		return nil, err
	}
	a := &ApiApp{}
	cfg.AppPackage = strings.ToLower(cfg.AppName)
	// a.root = path.Join(wd, cfg.AppPackage)
	a.root = wd
	cfg.ModelPackage = strings.ToLower(cfg.ModelName) + "model"
	cfg.ModelName = cfg.ModelName + "Po"

	a.cfg = cfg
	return a, nil
}

//创建所有文件夹
func (this *ApiApp) Mkdirs() error {
	// root := path.Join(this.root, this.cfg.AppPackage)
	name := []string{"handler", "logic", this.cfg.ModelPackage}
	for _, v := range name {
		tmp := path.Join(this.root, v)
		if _, err := utils.IsExistAndCreateDir(tmp); err != nil {
			return err
		}
	}
	return nil
}

func GenTpl(tpl string, value interface{}, f string) error {
	//不存在则进行生成
	if !utils.IsExists(f) {
		if err := utils.GenTpl(tpl, value, f); err != nil {
			return err
		}
	}
	return nil
}

//创建文件
//生成路由
func (this *ApiApp) GenRouter() error {

	f := path.Join(this.root, "router.go")
	return GenTpl(tpl.RouterTpl, this.cfg, f)
}

//生成model 数据
func (this *ApiApp) GenModel() error {

	f := path.Join(this.root, this.cfg.ModelPackage)
	if _, err := utils.IsExistAndCreateDir(f); err != nil {
		return err
	}

	if err := utils.GenTpl(tpl.ModelTpl, this.cfg, path.Join(f, "model.go")); err != nil {
		return err
	}
	return nil
}

func (this *ApiApp) GenGet() error {
	handlerName := path.Join(this.root, HandlerName, "get.go")

	if err := GenTpl(tpl.HandlerGetTpl, this.cfg, handlerName); err != nil {
		return errors.WithMessage(err, "gen get handlerTpl error: ")
	}

	logicName := path.Join(this.root, LogicName, "get.go")
	if err := GenTpl(tpl.LogicGetTpl, this.cfg, logicName); err != nil {
		return errors.WithMessage(err, "gen get logicTpl error: ")
	}
	return nil
}

func (this *ApiApp) GenPost() error {
	handlerName := path.Join(this.root, HandlerName, "post.go")

	if err := GenTpl(tpl.HandlerPostTpl, this.cfg, handlerName); err != nil {
		return errors.WithMessage(err, "gen post handlerTpl error: ")
	}

	logicName := path.Join(this.root, LogicName, "post.go")
	if err := GenTpl(tpl.LogicPostTpl, this.cfg, logicName); err != nil {
		return errors.WithMessage(err, "gen post logicTpl error: ")
	}
	return nil
}

func (this *ApiApp) GenPut() error {
	handlerName := path.Join(this.root, HandlerName, "put.go")

	if err := GenTpl(tpl.HandlerPutTpl, this.cfg, handlerName); err != nil {
		return errors.WithMessage(err, "gen put handlerTpl error: ")
	}

	logicName := path.Join(this.root, LogicName, "put.go")
	if err := GenTpl(tpl.LogicPutTpl, this.cfg, logicName); err != nil {
		return errors.WithMessage(err, "gen put logicTpl error: ")
	}
	return nil
}

func (this *ApiApp) GenDelete() error {
	handlerName := path.Join(this.root, HandlerName, "del.go")

	if err := GenTpl(tpl.HandlerDelTpl, this.cfg, handlerName); err != nil {
		return errors.WithMessage(err, "gen del handlerTpl error: ")
	}

	logicName := path.Join(this.root, LogicName, "del.go")
	if err := GenTpl(tpl.LogicDelTpl, this.cfg, logicName); err != nil {
		return errors.WithMessage(err, "gen del logicTpl error: ")
	}
	return nil
}

func GenTemplate(name string, cfg tpl.AppTplConfig) error {
	a, err := NewApiApp(cfg)
	if err != nil {
		return err
	}

	if err := a.Mkdirs(); err != nil {
		return errors.WithMessage(err, "gen root dirs error: ")
	}
	switch name {
	case "all":

		if err := a.GenModel(); err != nil {
			return err
		}
		if err := a.GenGet(); err != nil {
			return err
		}
		if err := a.GenPost(); err != nil {
			return err
		}
		if err := a.GenPut(); err != nil {
			return err
		}
		if err := a.GenDelete(); err != nil {
			return err
		}
		if err := a.GenRouter(); err != nil {
			return err
		}
		fmt.Println("app 模板生成")
		return nil

	case "model":
		if err := a.GenModel(); err != nil {
			return err
		}
		fmt.Println("MODEL生成")

	case "get":
		if err := a.GenGet(); err != nil {
			return err
		}
		fmt.Println("GET模板生成")

	case "post":
		if err := a.GenPost(); err != nil {
			return err
		}
		fmt.Println("POST模板生成")

	case "put":
		if err := a.GenPut(); err != nil {
			return err
		}
		fmt.Println("PUT模板生成")

	case "delete":
		if err := a.GenDelete(); err != nil {
			return err
		}
		fmt.Println("DELETE模板生成")

	case "route":

		if err := a.GenRouter(); err != nil {
			return err
		}
		fmt.Println("ROUTE模板生成")
	}
	return nil
}

// var a =
