package utils

import (
	"bufio"
	"errors"
	"io"
	"os"
	"path/filepath"
	"strings"
)

//根据mod获取mod名称

var ErrNotFountMod = errors.New("not found mod name")

func GetModName() (string, error) {
	pt, err := os.Getwd()
	modname := "go.mod"
	fname := ""
	tmp := pt
	for {
		fname = filepath.Join(pt, modname)
		if has, err := PathExists(fname); err == nil && has {
			break
		} else {

			pt = filepath.Dir(pt)
			if pt == tmp {
				return "", ErrNotFountMod
			} else {
				tmp = pt
			}
		}
	}

	f, err := os.Open(fname)
	if err != nil {
		return "", err
	}
	defer f.Close()

	buf := bufio.NewReader(f)
	for {
		// line,_,err:= buf.
		line, _, err := buf.ReadLine()
		if err == io.EOF {
			return "", ErrNotFountMod
		}
		if strings.Contains(string(line), "module") {
			modname := strings.ReplaceAll(string(line), "module", "")
			modname = strings.ReplaceAll(modname, " ", "")
			return modname, nil
		}
	}
}

func PathExists(path string) (bool, error) {
	_, err := os.Stat(path)
	if err == nil {
		return true, nil
	}
	//isnotexist来判断，是不是不存在的错误
	if os.IsNotExist(err) { //如果返回的错误类型使用os.isNotExist()判断为true，说明文件或者文件夹不存在
		return false, nil
	}
	return false, err //如果有错误了，但是不是不存在的错误，所以把这个错误原封不动的返回
}
