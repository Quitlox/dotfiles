// Package handler serves the Glance widget endpoints, turning OpenCode API
// data into rendered HTML fragments.
package handler

import (
	"context"
	"html/template"
	"log"
	"net/http"

	"github.com/quitlox/glance-extension-opencode/internal/model"
	"github.com/quitlox/glance-extension-opencode/internal/opencode"
)

// WidgetHandler renders the sessions and projects widgets.
type WidgetHandler struct {
	client      *opencode.Client
	tmpl        *template.Template
	externalURL string
}

// NewWidgetHandler creates a WidgetHandler that links to the OpenCode web UI
// at externalURL.
func NewWidgetHandler(client *opencode.Client, tmpl *template.Template, externalURL string) *WidgetHandler {
	return &WidgetHandler{client: client, tmpl: tmpl, externalURL: externalURL}
}

// Sessions renders the sessions widget.
func (h *WidgetHandler) Sessions(w http.ResponseWriter, r *http.Request) {
	projects, sessions, ok := h.fetchData(r.Context(), w)
	if !ok {
		return
	}

	worktrees := make(map[string]string, len(projects))
	for _, p := range projects {
		worktrees[p.ID] = p.Worktree
	}

	h.render(w, "Sessions", "sessions", tmplData{
		Sessions: buildSessionViews(sessions, worktrees, h.externalURL),
	})
}

// Projects renders the projects widget.
func (h *WidgetHandler) Projects(w http.ResponseWriter, r *http.Request) {
	projects, sessions, ok := h.fetchData(r.Context(), w)
	if !ok {
		return
	}

	h.render(w, "Projects", "projects", tmplData{
		Projects: buildProjectViews(projects, sessions, h.externalURL),
	})
}

// fetchData loads projects and non-empty sessions from the OpenCode API,
// writing a 502 response and returning ok=false on failure.
func (h *WidgetHandler) fetchData(ctx context.Context, w http.ResponseWriter) (projects []model.Project, sessions []model.Session, ok bool) {
	projects, err := h.client.FetchProjects(ctx)
	if err != nil {
		log.Printf("error fetching projects: %v", err)
		http.Error(w, "failed to fetch projects", http.StatusBadGateway)
		return nil, nil, false
	}

	sessions, err = h.client.FetchSessions(ctx)
	if err != nil {
		log.Printf("error fetching sessions: %v", err)
		http.Error(w, "failed to fetch sessions", http.StatusBadGateway)
		return nil, nil, false
	}

	return projects, dropEmptySessions(sessions), true
}

func (h *WidgetHandler) render(w http.ResponseWriter, title, name string, data tmplData) {
	w.Header().Set("Widget-Title", title)
	w.Header().Set("Widget-Content-Type", "html")
	if err := h.tmpl.ExecuteTemplate(w, name, data); err != nil {
		log.Printf("error executing template %s: %v", name, err)
	}
}

type tmplData struct {
	Projects []ProjectView
	Sessions []SessionView
}

func dropEmptySessions(sessions []model.Session) []model.Session {
	kept := make([]model.Session, 0, len(sessions))
	for _, s := range sessions {
		if !s.IsEmpty() {
			kept = append(kept, s)
		}
	}
	return kept
}
