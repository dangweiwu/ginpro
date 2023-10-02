package htmladmin

import (
	"archive/tar"
	"bytes"
	"embed"
	"github.com/dangweiwu/pkg/utils"
	"io"
	"os"
	"path/filepath"
)

/*
添加压缩文件
rm -rf src.tar
tar -cvf src.tar * .[!.]*

*/
//go:embed tpl/* tpl/.*
var F embed.FS

type Front struct {
	name string
}

func NewFront(name string) *Front {
	return &Front{name: name}
}

func (this *Front) Gen() error {
	//压缩文件
	//f, err := F.ReadFile(".")
	//
	//if err != nil {
	//	return err
	//}

	//wd, err := os.Getwd()
	//if err != nil {
	//	return err
	//}
	//
	//if err = os.MkdirAll(path.Join(wd, this.name), 0755); err != nil {
	//	return err
	//}
	//return UnTar(f, path.Join(wd, this.name))

	r := utils.NewCopyFile(this.name, F)
	return r.Do()

}

func GenFront(name string) error {
	return NewFront(name).Gen()
}

func UnTar(bts []byte, target string) error {

	tarReader := tar.NewReader(bytes.NewBuffer(bts))

	for {
		header, err := tarReader.Next()
		if err == io.EOF {
			break
		} else if err != nil {
			return err
		}

		pt := filepath.Join(target, header.Name)
		info := header.FileInfo()
		if info.IsDir() {
			if err = os.MkdirAll(pt, 0755); err != nil {
				return err
			}
			continue
		}

		file, err := os.OpenFile(pt, os.O_CREATE|os.O_TRUNC|os.O_WRONLY, info.Mode())
		if err != nil {
			return err
		}
		defer file.Close()
		_, err = io.Copy(file, tarReader)
		if err != nil {
			return err
		}
	}
	return nil
}
