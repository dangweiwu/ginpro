package main

import (
	"github.com/dangweiwu/ginpro/option"
	"github.com/jessevdk/go-flags"
)

func main() {
	p := flags.NewParser(&option.Opt, flags.Default)
	p.ShortDescription = "v0.1 go server framework"
	p.LongDescription = `v0.1 go server framework`
	p.Parse()
}
