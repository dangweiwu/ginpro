package gencode

import (
	"fmt"
	"os"
	"path"
	"regexp"
	"strings"
)

// 解析model
type ModelObj struct {
	root      string
	filePaths []string
	data      *HtmlValue
}

func NewModelObj(root string) *ModelObj {
	return &ModelObj{root, []string{}, &HtmlValue{}}
}

func (this *ModelObj) GetFiles() error {
	files, err := os.ReadDir(this.root)
	if err != nil {
		return err
	}
	for _, fi := range files {
		if !fi.IsDir() {
			this.filePaths = append(this.filePaths, path.Join(this.root, fi.Name()))
		}
	}
	//fmt.Println(this.filePaths)
	return nil
}

func (this *ModelObj) GetData() *HtmlValue {
	return this.data
}

func (this *ModelObj) ParseData() error {

	for _, f := range this.filePaths {
		bts, err := os.ReadFile(f)
		if err != nil {
			return fmt.Errorf("读物文件失败:%w", err)
		}
		if vo, has := this.DoView(bts); has {
			this.data.View = vo
			//fmt.Println(vo)
		}
		if create, has := this.DoCreate(bts); has {
			//fmt.Println(create)
			this.data.Create = create
		}

		if update, has := this.DoUpdate(bts); has {
			//fmt.Println(update)
			this.data.Update = update
		}
		if queryRule, has := this.DoQueryRule(bts); has {
			//fmt.Println(queryRule)
			this.data.QueryRule = queryRule
		}
	}
	return nil
}

// 解析view
func (this *ModelObj) DoView(body []byte) ([]FormItem, bool) {
	reg := regexp.MustCompile(`(?U)//\s*@view[\s\S]+{([\s\S]+)}`)
	bds := reg.FindStringSubmatch(string(body))
	a := []FormItem{}

	if len(bds) > 1 {
		rows := strings.Split(bds[1], "\n")
		for _, v := range rows {
			//fmt.Println("row:", v)
			if strings.Contains(v, "extensions") {
				reg2 := regexp.MustCompile(`(?U)\s+(\w+)\s+(\w+)\s+.*json:"(\w+)".*extensions:"\s*x-name=(.+),`)
				r := reg2.FindStringSubmatch(v)
				a = append(a, FormItem{Name: r[4], Key: r[3], Type: r[2]})
			}
		}
		return a, true
	} else {
		return nil, false
	}
}

// 解析 create
func (this *ModelObj) DoCreate(body []byte) ([]FormItem, bool) {
	reg := regexp.MustCompile(`(?U)//\s*@create[\s\S]+{([\s\S]+)}`)
	bds := reg.FindStringSubmatch(string(body))
	a := []FormItem{}

	if len(bds) > 1 {
		rows := strings.Split(bds[1], "\n")
		for _, v := range rows {
			if strings.Contains(v, "extensions") {
				reg2 := regexp.MustCompile(`(?U)\s+(\w+)\s+(\w+)\s+.*json:"(\w+)".*binding:"(.+)".*extensions:"\s*x-name=(.+),`)
				r := reg2.FindStringSubmatch(v)
				_rule := r[4]
				rule := strings.Split(_rule, ",")
				a = append(a, FormItem{Name: r[5], Key: r[3], Type: r[2], Rule: rule})
			}
		}
		return a, true
	} else {
		return a, false
	}
}

// 解析 update
func (this *ModelObj) DoUpdate(body []byte) ([]FormItem, bool) {
	reg := regexp.MustCompile(`(?U)//\s*@update[\s\S]+{([\s\S]+)}`)
	bds := reg.FindStringSubmatch(string(body))
	a := []FormItem{}

	if len(bds) > 1 {
		rows := strings.Split(bds[1], "\n")
		for _, v := range rows {
			if strings.Contains(v, "extensions") {
				reg2 := regexp.MustCompile(`(?U)\s+(\w+)\s+(\w+)\s+.*json:"(\w+)".*binding:"(.+)".*extensions:"\s*x-name=(.+),`)
				r := reg2.FindStringSubmatch(v)
				_rule := r[4]
				rule := strings.Split(_rule, ",")
				a = append(a, FormItem{Name: r[5], Key: r[3], Type: r[2], Rule: rule})
			}
		}
		return a, true
	} else {
		return a, false
	}
}

// 解析 queryRule
func (this *ModelObj) DoQueryRule(body []byte) ([]FormItem, bool) {
	reg := regexp.MustCompile(`(?U)//\s*@queryrule[\s\S]+{([\s\S]+)}`)
	bds := reg.FindStringSubmatch(string(body))
	a := []FormItem{}

	if len(bds) > 1 {
		rows := strings.Split(bds[1], "\n")
		for _, v := range rows {
			if strings.Contains(v, "//") {

				reg2 := regexp.MustCompile(`(?U)\s+"(\w+)"\s*:\s*"\w*"\s*,\s*//\s*(.*),`)
				r := reg2.FindStringSubmatch(v)
				a = append(a, FormItem{Name: r[2], Key: r[1]})
			}
		}
		return a, true
	} else {
		return a, false
	}
}
