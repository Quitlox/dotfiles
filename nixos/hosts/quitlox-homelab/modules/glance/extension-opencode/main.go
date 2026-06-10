// Binary opencode-glance-extension serves an OpenCode activity widget for Glance.
package main

import (
	"cmp"
	"context"
	"embed"
	"errors"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"
	"os/signal"
	"strconv"
	"syscall"
	"time"

	"github.com/quitlox/glance-extension-opencode/internal/handler"
	"github.com/quitlox/glance-extension-opencode/internal/opencode"
)

//go:embed templates/*.html
var templateFS embed.FS

func main() {
	if err := run(); err != nil {
		log.Fatal(err)
	}
}

func run() error {
	// The URL defaults are deliberate: this widget is purpose-built for the
	// quitlox-homelab deployment; the env vars exist for overrides.
	baseURL := cmp.Or(os.Getenv("OPENCODE_BASE_URL"), "https://opencode.home.quitlox.dev")
	username := os.Getenv("OPENCODE_USERNAME")
	password := os.Getenv("OPENCODE_PASSWORD")
	externalURL := cmp.Or(os.Getenv("OPENCODE_EXTERNAL_URL"), "https://opencode.home.quitlox.dev")

	if username == "" || password == "" {
		return errors.New("missing required env vars OPENCODE_USERNAME and OPENCODE_PASSWORD")
	}

	port, err := strconv.Atoi(cmp.Or(os.Getenv("PORT"), "8080"))
	if err != nil {
		return errors.New("env var PORT must be a number")
	}

	tmpl, err := template.New("").Funcs(template.FuncMap{
		"formatCost":     handler.FormatCost,
		"formatTokens":   handler.FormatTokens,
		"workspaceLabel": handler.WorkspaceLabel,
		"shortenModel":   handler.ShortenModel,
	}).ParseFS(templateFS, "templates/*.html")
	if err != nil {
		return fmt.Errorf("parsing templates: %w", err)
	}

	client := opencode.NewClient(baseURL, username, password)
	h := handler.NewWidgetHandler(client, tmpl, externalURL)

	mux := http.NewServeMux()
	mux.HandleFunc("GET /sessions", h.Sessions)
	mux.HandleFunc("GET /projects", h.Projects)
	mux.HandleFunc("GET /healthz", func(w http.ResponseWriter, _ *http.Request) {
		w.WriteHeader(http.StatusOK)
	})

	srv := &http.Server{
		Addr:              ":" + strconv.Itoa(port),
		Handler:           mux,
		ReadHeaderTimeout: 10 * time.Second,
		// Must exceed the two sequential 30s upstream fetches a widget
		// request can make.
		WriteTimeout: 90 * time.Second,
		IdleTimeout:  60 * time.Second,
	}

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	errCh := make(chan error, 1)
	go func() {
		log.Printf("listening on :%d", port)
		errCh <- srv.ListenAndServe()
	}()

	select {
	case err := <-errCh:
		return err
	case <-ctx.Done():
		log.Print("shutting down")
		shutdownCtx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		if err := srv.Shutdown(shutdownCtx); err != nil {
			return fmt.Errorf("shutdown: %w", err)
		}
	}
	return nil
}
