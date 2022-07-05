package {{.AppPackage}}

import (
	"{{.Module}}/internal/app/{{.AppPackage}}/handler"
	"{{.Module}}/internal/router"
	"{{.Module}}/internal/serctx"
)

func Route(r *router.Router, serCtx *serctx.ServerContext) {
	{{if .HasGet}}
	r.{{- .RouterType -}}.GET("/{{- .RouterUrl -}}", router.Do(serCtx, handler.Get))
	{{- end}}
	{{if .HasPost}}
	r.{{- .RouterType -}}.POST("/{{- .RouterUrl -}}", router.Do(serCtx, handler.Post))
	{{- end}}
	{{if .HasPut}}
	r.{{- .RouterType -}}.PUT("/{{- .RouterUrl -}}/:id", router.Do(serCtx, handler.Put))
	{{- end}}
	{{if .HasDelete}}
	r.{{- .RouterType -}}.DELETE("/{{- .RouterUrl -}}/:id", router.Do(serCtx, handler.Delete))
	{{- end}}
}