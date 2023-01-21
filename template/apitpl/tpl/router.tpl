package {{.ApiPackage}}

import (
	"{{.Module}}/internal/api/{{.ApiPackage}}/api"
	"{{.Module}}/internal/router"
	"{{.Module}}/internal/ctx"
)

func Route(r *router.Router, sc *ctx.ServerContext) {

	r.{{- .RouterType -}}.GET("/{{- .RouterUrl -}}", router.Do(sc, api.New{{.ApiName}}Query))

	r.{{- .RouterType -}}.POST("/{{- .RouterUrl -}}", router.Do(sc, api.New{{.ApiName}}Create))

	r.{{- .RouterType -}}.PUT("/{{- .RouterUrl -}}/:id", router.Do(sc, api.New{{.ApiName}}Update))

	r.{{- .RouterType -}}.DELETE("/{{- .RouterUrl -}}/:id", router.Do(sc, api.New{{.ApiName}}Del))
}