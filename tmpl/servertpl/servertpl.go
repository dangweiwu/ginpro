package servertpl

import (
	"embed"
	"fmt"
	"github.com/dangweiwu/ginpro/pkg"
	"go/format"
	"io/fs"
	"os"
	"path"
	"path/filepath"
	"strings"
)

const (
	ZIPFILE = "DEMOX.zip"
)

//go:embed DEMOX.zip
var projectfile embed.FS

func GenCode(name string) error {
	//fmt.Printf("[info]:准备生成项目:%s\n", name)
	wd, err := os.Getwd()
	if err != nil {
		return err
	}
	root := path.Join(wd, name)

	pkg.UnZipEmbedFile(ZIPFILE, root, projectfile, func(filename string, cont []byte) ([]byte, error) {
		body := string(cont)
		rt := []byte{}
		if filepath.Ext(filename) == ".go" {
			rt = []byte(strings.Replace(body, "DEMOX", name, -1))
			rt, err = format.Source([]byte(rt))
			if err != nil {
				fmt.Println("[error]:", err)
			}
		} else {
			rt = cont
		}
		//strings.Replace(body)//
		//bts, err := format.Source([]byte(rt))
		//if err != nil {
		//	fmt.Println("[error]:", err)
		//	return nil, err
		//}
		return rt, nil
	})

	return nil
}

type ReadAt struct {
	fs.File
}
