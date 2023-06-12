package utils

import (
	"embed"
	"errors"
	"fmt"
	"os"
	"path"
)

/*
*
生成文件
*/
type Item struct {
	From string
	To   string
}

type CopyFile struct {
	f     embed.FS
	name  string
	root  string
	files []Item
}

func NewCopyFile(name string, f embed.FS) *CopyFile {
	return &CopyFile{f, name, "", []Item{}}
}

func (this *CopyFile) Do() error {
	root, err := this.f.ReadDir(".")
	if err != nil {
		return err
	}
	if len(root) != 1 {
		return errors.New("embed.FS打包数据缺少根目录")
	}
	if !root[0].IsDir() {
		return errors.New("embed.FS打包数据缺少根目录")
	}
	this.root = root[0].Name()
	if err := this.DoDir(""); err != nil {
		return err
	}
	return this.CreateFile()

}

func (this *CopyFile) DoDir(pt string) error {
	dirs, err := this.f.ReadDir(path.Join(this.root, pt))
	if err != nil {
		return err
	}
	for _, v := range dirs {
		if v.IsDir() {
			if err := this.DoDir(path.Join(pt, v.Name())); err != nil {
				return err
			}
		} else {
			this.DoFile(path.Join(pt, v.Name()))
		}
	}
	return nil
}

func (this *CopyFile) DoFile(pt string) error {
	this.files = append(this.files, Item{
		From: path.Join(this.root, pt),
		To:   path.Join(this.name, pt),
	})
	return nil
}

func (this *CopyFile) GetFiles() {
	for k, v := range this.files {
		fmt.Printf("%d: from:%s to:%s\n", k, v.From, v.To)
	}
}

func (this *CopyFile) CreateFile() error {
	for _, v := range this.files {
		r, err := this.f.ReadFile(v.From)
		if err != nil {
			return err
		}
		dr, _ := path.Split(v.To)
		_, err = os.Stat(dr)
		if os.IsNotExist(err) {
			if err = os.MkdirAll(dr, 0755); err != nil {
				return err
			}
		}
		if err != nil {
			return err
		}

		if err := os.WriteFile(v.To, r, 0755); err != nil {
			return err
		}
	}
	return nil
}
