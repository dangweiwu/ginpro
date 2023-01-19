package tpl

import (
	_ "embed"
)

var (
	//go:embed router.tpl
	RouterTpl string

	//go:embed model.tpl
	ModelTpl string

	//go:embed handler_get.tpl
	HandlerGetTpl string

	// //go:embed logic_get.tpl
	// LogicGetTpl string

	//go:embed handler_post.tpl
	HandlerPostTpl string

	// //go:embed logic_post.tpl
	// LogicPostTpl string

	//go:embed handler_put.tpl
	HandlerPutTpl string

	// //go:embed logic_put.tpl
	// LogicPutTpl string

	//go:embed handler_del.tpl
	HandlerDelTpl string

	// //go:embed logic_del.tpl
	// LogicDelTpl string
)
