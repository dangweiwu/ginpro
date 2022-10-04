package utils

import (
	"fmt"
	"os"
	"path/filepath"
	"testing"
)

func TestGetModName(t *testing.T) {
	s, e := GetModName()

	if e != nil {
		t.Fatal(e)
	}
	if s != "gs" {
		t.Fatalf("结果错误 :%s", s)
	}

	a, e := os.Getwd()
	aa := filepath.Base(a)
	fmt.Println("base", aa, e)

}
