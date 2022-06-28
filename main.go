package main

import (
	"fmt"
	"gs/gscli"
	"os"
)

func main() {
	if err := gscli.Cmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
