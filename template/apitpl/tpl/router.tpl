package {{.ApiPackage}}

import (
	"{{.Module}}/internal/app/{{.ApiPackage}}/api"
	"{{.Module}}/internal/router"
	"{{.Module}}/internal/ctx"
)

// @group | {{.ApiName}} | 1 | title | desc
func Route(r *router.Router, appctx *ctx.AppContext) {

	r.{{- .RouterType -}}.GET("/{{- .RouterUrl -}}", router.Do(appctx, api.New{{.ApiName}}Query))

	r.{{- .RouterType -}}.POST("/{{- .RouterUrl -}}", router.Do(appctx, api.New{{.ApiName}}Create))

	r.{{- .RouterType -}}.PUT("/{{- .RouterUrl -}}/:id", router.Do(appctx, api.New{{.ApiName}}Update))

	r.{{- .RouterType -}}.DELETE("/{{- .RouterUrl -}}/:id", router.Do(appctx, api.New{{.ApiName}}Del))
}