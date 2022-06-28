package utils

import (
	"os"
)

//路径是否存在
func IsDir(pt string) bool {
	s, err := os.Stat(pt)
	if err != nil {
		return false
	}
	return s.IsDir()
}

//目录是否存在 不存在则创建
func IsExistAndCreateDir(pt string) (bool, error) {
	if _, err := os.Stat(pt); os.IsNotExist(err) {
		if err := os.MkdirAll(pt, os.ModePerm); err != nil {
			return false, err
		} else {
			return true, nil
		}
	} else {
		return true, err
	}
}

//判断目录和文件是否存在
func IsExists(pt string) bool {
	_, err := os.Stat(pt)
	return !os.IsNotExist(err)
}
