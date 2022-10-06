package main

import (
    "{{.Module}}/cmd"
    "{{.Module}}/internal/config"
    "flag"
    "fmt"
    "gs/pkg/yamconfig"
    "log"
    "os"
)

var configFile = flag.String("f", "./config/config.yaml", "the config file")

func main() {
	flag.Usage = Usage
	flag.Parse()

	var c config.Config
	yamconfig.MustLoad(*configFile, &c)
	if len(os.Args) < 2 {
		flag.Usage()
		os.Exit(1)
	}

	cmder := os.Args[1]
	switch cmder {
	case "run":
		cmd.Server(c)
	case "super":
		super := cmd.NewSuperman(c)
		if err := super.CreateSuperman(); err != nil {
			log.Println(err)
		}
    default:
        flag.Usage()
        os.Exit(1)
	}
}

func Usage() {
	fmt.Println("go server v1.0")
	fmt.Println("main [cmd] [tag]")
	fmt.Println("cmd:")
	fmt.Println("   run: server run")
    fmt.Println("   super: create or update super account")
	fmt.Println("tag:")
	flag.PrintDefaults()
}
