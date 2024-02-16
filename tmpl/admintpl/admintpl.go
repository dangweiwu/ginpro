package admintpl

import (
	"embed"
	"fmt"
	"github.com/dangweiwu/ginpro/pkg"
	"go/format"
	"os"
	"path"
	"path/filepath"
	"strings"
)

const (
	ZIPFILE = "DEMOX_ADMIN.zip"
)

//go:embed DEMOX_ADMIN.zip
var projectfile embed.FS

func GenCode(name string) error {
	wd, err := os.Getwd()
	if err != nil {
		return err
	}
	root := path.Join(wd, name)

	err = pkg.UnZipEmbedFile(ZIPFILE, root, projectfile, func(filename string, cont []byte) ([]byte, error) {
		body := string(cont)
		rt := []byte{}
		if filepath.Ext(filename) == ".go" {
			rt = []byte(strings.Replace(body, "DEMOX_ADMIN", name, -1))
			rt, err = format.Source([]byte(rt))
			if err != nil {
				fmt.Println("[error]:", err)
			}
		} else {
			rt = cont
		}
		return rt, nil
	})

	return err
}
