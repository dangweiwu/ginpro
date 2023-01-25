package main

import (
	"{{.Module}}/option"
	"github.com/jessevdk/go-flags"
)

func main() {
	p := flags.NewParser(&option.Opt, flags.Default)
	p.ShortDescription = "v1.0 server"
	p.LongDescription = `v1.0 Server`
	p.Parse()
}
