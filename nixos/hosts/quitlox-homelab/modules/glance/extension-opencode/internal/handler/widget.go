// Package handler serves the OpenCode widget HTTP endpoint.
package handler

import (
	"fmt"
	"html/template"
	"log"
	"net/http"
	"sort"
	"strconv"
	"strings"

	"github.com/quitlox/glance-extension-opencode/internal/model"
	"github.com/quitlox/glance-extension-opencode/internal/opencode"
)

// WidgetHandler renders OpenCode activity as an HTML widget.
type WidgetHandler struct {
	client *opencode.Client
	tmpl   *template.Template
}

// NewWidgetHandler creates a WidgetHandler with the given client and template.
func NewWidgetHandler(client *opencode.Client, tmpl *template.Template) *WidgetHandler {
	return &WidgetHandler{client: client, tmpl: tmpl}
}

func (h *WidgetHandler) ServeHTTP(w http.ResponseWriter, _ *http.Request) {
	projects, err := h.client.FetchProjects()
	if err != nil {
		log.Printf("error fetching projects: %v", err)
		http.Error(w, "failed to fetch projects", http.StatusBadGateway)
		return
	}

	sessions, err := h.client.FetchSessions()
	if err != nil {
		log.Printf("error fetching sessions: %v", err)
		http.Error(w, "failed to fetch sessions", http.StatusBadGateway)
		return
	}

	projectViews := merge(projects, sessions)
	sessionViews := buildSessionViews(sessions)

	data := tmplData{
		Projects: projectViews,
		Sessions: sessionViews,
	}

	w.Header().Set("Widget-Title", "OpenCode Activity")
	w.Header().Set("Widget-Content-Type", "html")

	err = h.tmpl.ExecuteTemplate(w, "layout", data)
	if err != nil {
		log.Printf("error executing template: %v", err)
	}
}

func merge(projects []model.Project, sessions []model.Session) []model.ProjectView {
	sessionMap := make(map[string][]model.Session)
	for _, s := range sessions {
		sessionMap[s.ProjectID] = append(sessionMap[s.ProjectID], s)
	}

	views := make([]model.ProjectView, 0, len(projects))
	for _, p := range projects {
		projSessions := sessionMap[p.ID]
		var totalCost float64
		var totalTokens int64
		var lastUpdated int64

		if p.Time.Updated > 0 {
			lastUpdated = p.Time.Updated
		}

		for _, s := range projSessions {
			totalCost += s.Cost
			totalTokens += int64(s.Tokens.Input) + int64(s.Tokens.Output) + int64(s.Tokens.Cache.Read)
			if s.Time.Updated > lastUpdated {
				lastUpdated = s.Time.Updated
			}
		}

		views = append(views, model.ProjectView{
			ID:              p.ID,
			ShortName:       model.DeriveShortName(p.Worktree),
			FullPath:        p.Worktree,
			Workspace:       model.DeriveWorkspace(p.Worktree),
			VCS:             p.VCS,
			SessionCount:    len(projSessions),
			TotalCost:       totalCost,
			TotalTokens:     totalTokens,
			LastUpdatedSecs: lastUpdated / 1000,
			Active:          model.IsActive(lastUpdated),
		})
	}

	sort.Slice(views, func(i, j int) bool {
		return views[i].LastUpdatedSecs > views[j].LastUpdatedSecs
	})

	return views
}

func buildSessionViews(sessions []model.Session) []model.SessionView {
	sorted := make([]model.Session, len(sessions))
	copy(sorted, sessions)
	sort.Slice(sorted, func(i, j int) bool {
		return sorted[i].Time.Updated > sorted[j].Time.Updated
	})

	views := make([]model.SessionView, 0, len(sorted))
	for _, s := range sorted {
		views = append(views, model.SessionView{
			ID:          s.ID,
			Title:       s.Title,
			ModelID:     s.Model.ID,
			Agent:       s.Agent,
			UpdatedMs:   s.Time.Updated,
			UpdatedSecs: s.Time.Updated / 1000,
			Active:      model.IsActive(s.Time.Updated),
		})
	}
	return views
}

type tmplData struct {
	Projects []model.ProjectView
	Sessions []model.SessionView
}

// FormatCost formats a cost value as a dollar string.
func FormatCost(c float64) string {
	if c < 0.01 {
		return fmt.Sprintf("$%.4f", c)
	}
	return fmt.Sprintf("$%.2f", c)
}

// FormatTokens formats a token count as a human-readable string (e.g. "1.2M", "3.4k").
func FormatTokens(t int64) string {
	switch {
	case t >= 1_000_000:
		return fmt.Sprintf("%.1fM", float64(t)/1_000_000)
	case t >= 1_000:
		return fmt.Sprintf("%.1fk", float64(t)/1_000)
	default:
		return strconv.FormatInt(t, 10)
	}
}

// WorkspaceLabel maps internal workspace names to display labels.
func WorkspaceLabel(ws string) string {
	if ws == "" {
		return ""
	}
	switch ws {
	case "hobby":
		return "personal"
	case "tno":
		return "work"
	case "contrib":
		return "oss"
	default:
		return ws
	}
}

// ShortenModel returns the short name of a model ID (the part after the last "/").
func ShortenModel(id string) string {
	parts := strings.Split(id, "/")
	return parts[len(parts)-1]
}