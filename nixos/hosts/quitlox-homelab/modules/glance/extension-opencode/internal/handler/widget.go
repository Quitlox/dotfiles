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

type WidgetHandler struct {
	client      *opencode.Client
	tmpl        *template.Template
	externalURL string
}

func NewWidgetHandler(client *opencode.Client, tmpl *template.Template, externalURL string) *WidgetHandler {
	return &WidgetHandler{client: client, tmpl: tmpl, externalURL: externalURL}
}

func (h *WidgetHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	switch r.URL.Path {
	case "/sessions":
		h.handleSessions(w, r)
	case "/projects":
		h.handleProjects(w, r)
	default:
		http.NotFound(w, r)
	}
}

func (h *WidgetHandler) handleSessions(w http.ResponseWriter, _ *http.Request) {
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

	sessions = dropEmptySessions(sessions)

	worktreeMap := make(map[string]string, len(projects))
	for _, p := range projects {
		worktreeMap[p.ID] = p.Worktree
	}

	views := buildSessionViews(sessions, worktreeMap, h.externalURL)

	data := tmplData{Sessions: views}

	w.Header().Set("Widget-Title", "Sessions")
	w.Header().Set("Widget-Content-Type", "html")

	if err := h.tmpl.ExecuteTemplate(w, "sessions", data); err != nil {
		log.Printf("error executing template: %v", err)
	}
}

func (h *WidgetHandler) handleProjects(w http.ResponseWriter, _ *http.Request) {
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

	sessions = dropEmptySessions(sessions)

	views := merge(projects, sessions, h.externalURL)

	data := tmplData{Projects: views}

	w.Header().Set("Widget-Title", "Projects")
	w.Header().Set("Widget-Content-Type", "html")

	if err := h.tmpl.ExecuteTemplate(w, "projects", data); err != nil {
		log.Printf("error executing template: %v", err)
	}
}

func dropEmptySessions(sessions []model.Session) []model.Session {
	kept := make([]model.Session, 0, len(sessions))
	for _, s := range sessions {
		if !model.IsEmptySession(s) {
			kept = append(kept, s)
		}
	}
	return kept
}

func merge(projects []model.Project, sessions []model.Session, externalURL string) []model.ProjectView {
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
			Link:            model.ProjectLink(externalURL, p.Worktree),
		})
	}

	sort.Slice(views, func(i, j int) bool {
		return views[i].LastUpdatedSecs > views[j].LastUpdatedSecs
	})

	return views
}

func buildSessionViews(sessions []model.Session, worktreeMap map[string]string, externalURL string) []model.SessionView {
	sorted := make([]model.Session, 0, len(sessions))
	for _, s := range sessions {
		if s.IsSubagent() {
			continue
		}
		sorted = append(sorted, s)
	}

	sort.Slice(sorted, func(i, j int) bool {
		return sorted[i].Time.Updated > sorted[j].Time.Updated
	})

	views := make([]model.SessionView, 0, len(sorted))
	for _, s := range sorted {
		worktree := s.ProjectID
		if wt, ok := worktreeMap[s.ProjectID]; ok {
			worktree = wt
		}

		views = append(views, model.SessionView{
			ID:          s.ID,
			Title:       s.Title,
			ModelID:     s.Model.ID,
			Agent:       s.Agent,
			UpdatedMs:   s.Time.Updated,
			UpdatedSecs: s.Time.Updated / 1000,
			Active:      model.IsActive(s.Time.Updated),
			Link:        model.SessionLink(externalURL, worktree, s.ID),
		})
	}
	return views
}

type tmplData struct {
	Projects []model.ProjectView
	Sessions []model.SessionView
}

func FormatCost(c float64) string {
	switch {
	case c == 0:
		return "$0.00"
	case c < 0.01:
		return "<$0.01"
	default:
		return fmt.Sprintf("$%.2f", c)
	}
}

func FormatTokens(t int64) string {
	abbrev := func(v float64, suffix string) string {
		return strings.TrimSuffix(fmt.Sprintf("%.1f", v), ".0") + suffix
	}
	switch {
	case t >= 1_000_000:
		return abbrev(float64(t)/1_000_000, "M")
	case t >= 1_000:
		return abbrev(float64(t)/1_000, "k")
	default:
		return strconv.FormatInt(t, 10)
	}
}

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

func ShortenModel(id string) string {
	parts := strings.Split(id, "/")
	return parts[len(parts)-1]
}
