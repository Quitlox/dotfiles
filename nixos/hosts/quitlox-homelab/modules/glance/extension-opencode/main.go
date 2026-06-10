// Binary opencode-glance-extension serves an OpenCode activity widget for Glance.
package main

import (
	"cmp"
	"embed"
	"html/template"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/quitlox/glance-extension-opencode/internal/handler"
	"github.com/quitlox/glance-extension-opencode/internal/opencode"
)

//go:embed templates/*.html
var templateFS embed.FS

func main() {
	baseURL := cmp.Or(os.Getenv("OPENCODE_BASE_URL"), "https://opencode.home.quitlox.dev")
	username := os.Getenv("OPENCODE_USERNAME")
	password := os.Getenv("OPENCODE_PASSWORD")
	externalURL := cmp.Or(os.Getenv("OPENCODE_EXTERNAL_URL"), "https://opencode.home.quitlox.dev")
	port := cmp.Or(os.Getenv("PORT"), "8080")

	if username == "" || password == "" {
		log.Fatal("OPENCODE_USERNAME and OPENCODE_PASSWORD must be set")
	}

	tmpl, err := template.New("").Funcs(template.FuncMap{
		"formatCost":     handler.FormatCost,
		"formatTokens":   handler.FormatTokens,
		"workspaceLabel": handler.WorkspaceLabel,
		"shortenModel":   handler.ShortenModel,
	}).ParseFS(templateFS, "templates/*.html")
	if err != nil {
		log.Fatalf("parsing templates: %v", err)
	}

	client := opencode.NewClient(baseURL, username, password)
	h := handler.NewWidgetHandler(client, tmpl, externalURL)

	mux := http.NewServeMux()
	mux.Handle("/", h)

	srv := &http.Server{
		Addr:              ":" + port,
		Handler:           mux,
		ReadHeaderTimeout: 10 * time.Second,
		IdleTimeout:       60 * time.Second,
	}

	log.Printf("listening on %s", srv.Addr)
	if err := srv.ListenAndServe(); err != nil {
		log.Fatal(err)
	}
}
