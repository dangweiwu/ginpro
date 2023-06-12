package gencode

import (
	"fmt"
	"testing"
)

func TestParse(t *testing.T) {
	obj := NewModelObj("./adminmodel")
	obj.GetFiles()
	obj.ParseData()
	d := obj.GetData()
	fmt.Println(d)

}
