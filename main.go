package main

import (
	"github.com/jessevdk/go-flags"
	"github.com/dangweiwu/ginpro/option"
)

func main() {
	p := flags.NewParser(&option.Opt, flags.Default)
	p.ShortDescription = "v0.1 go server framework"
	p.LongDescription = `v0.1 go server framework`
	p.Parse()
}
