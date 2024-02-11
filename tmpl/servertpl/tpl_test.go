package servertpl

import (
	"fmt"
	"os"
	"path"
	"testing"
)

func TestT(t *testing.T) {
	//fmt.Println(os.Getenv(/"GOPACKAGE"))/
	pt, err := os.Getwd()
	if err != nil {
		fmt.Println(err)
	}

	pt = path.Join(pt, "server_dmo")

}
