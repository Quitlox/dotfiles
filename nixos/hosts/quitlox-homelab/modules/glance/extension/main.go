package main

import (
	"embed"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"

	"github.com/quitlox/opencode-glance-extension/internal/handler"
	"github.com/quitlox/opencode-glance-extension/internal/opencode"
)

//go:embed templates/*.html
var templateFS embed.FS

func main() {
	baseURL := envOrDefault("OPENCODE_BASE_URL", "https://opencode.home.quitlox.dev")
	username := os.Getenv("OPENCODE_USERNAME")
	password := os.Getenv("OPENCODE_PASSWORD")
	port := envOrDefault("PORT", "8080")

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
	h := handler.NewWidgetHandler(client, tmpl)

	http.Handle("/", h)
	addr := fmt.Sprintf(":%s", port)
	log.Printf("listening on %s", addr)
	if err := http.ListenAndServe(addr, nil); err != nil {
		log.Fatal(err)
	}
}

func envOrDefault(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}