package main

import (
	"fmt"
	"gs/cli"
	"os"
)

func main() {
	if err := cli.Cmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
