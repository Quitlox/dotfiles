package handler

import (
	"cmp"
	"encoding/base64"
	"path/filepath"
	"slices"
	"strings"
	"time"

	"github.com/quitlox/glance-extension-opencode/internal/model"
)

// ProjectView is a display-ready project with aggregated session data.
type ProjectView struct {
	ShortName       string
	FullPath        string
	Workspace       string
	SessionCount    int
	TotalCost       float64
	TotalTokens     int64
	LastUpdatedSecs int64
	Active          bool
	Link            string
}

// SessionView is a display-ready representation of a session.
type SessionView struct {
	Title       string
	ModelID     string
	Agent       string
	UpdatedSecs int64
	Active      bool
	Link        string
}

// buildProjectViews merges projects with their sessions' aggregated cost and
// token totals, newest first. The catch-all root project is omitted.
func buildProjectViews(projects []model.Project, sessions []model.Session, externalURL string) []ProjectView {
	sessionsByProject := make(map[string][]model.Session)
	for _, s := range sessions {
		sessionsByProject[s.ProjectID] = append(sessionsByProject[s.ProjectID], s)
	}

	views := make([]ProjectView, 0, len(projects))
	for _, p := range projects {
		if isRootWorktree(p.Worktree) {
			continue
		}

		projSessions := sessionsByProject[p.ID]
		var totalCost float64
		var totalTokens int64
		lastUpdated := p.Time.Updated
		for _, s := range projSessions {
			totalCost += s.Cost
			totalTokens += int64(s.Tokens.Input) + int64(s.Tokens.Output) + int64(s.Tokens.Cache.Read)
			lastUpdated = max(lastUpdated, s.Time.Updated)
		}

		views = append(views, ProjectView{
			ShortName:       deriveShortName(p.Worktree),
			FullPath:        p.Worktree,
			Workspace:       deriveWorkspace(p.Worktree),
			SessionCount:    len(projSessions),
			TotalCost:       totalCost,
			TotalTokens:     totalTokens,
			LastUpdatedSecs: lastUpdated / 1000,
			Active:          isActive(lastUpdated),
			Link:            projectLink(externalURL, p.Worktree),
		})
	}

	slices.SortFunc(views, func(a, b ProjectView) int {
		return cmp.Compare(b.LastUpdatedSecs, a.LastUpdatedSecs)
	})
	return views
}

// buildSessionViews returns display views for user-started sessions, newest first.
func buildSessionViews(sessions []model.Session, worktrees map[string]string, externalURL string) []SessionView {
	visible := make([]model.Session, 0, len(sessions))
	for _, s := range sessions {
		if !s.IsSubagent() {
			visible = append(visible, s)
		}
	}

	slices.SortFunc(visible, func(a, b model.Session) int {
		return cmp.Compare(b.Time.Updated, a.Time.Updated)
	})

	views := make([]SessionView, 0, len(visible))
	for _, s := range visible {
		// Fall back to the project ID when the project list doesn't cover the
		// session's project; the link will 404 in the web UI, but the session
		// is still worth showing.
		worktree := s.ProjectID
		if wt, ok := worktrees[s.ProjectID]; ok {
			worktree = wt
		}

		views = append(views, SessionView{
			Title:       s.Title,
			ModelID:     s.Model.ID,
			Agent:       s.Agent,
			UpdatedSecs: s.Time.Updated / 1000,
			Active:      isActive(s.Time.Updated),
			Link:        sessionLink(externalURL, worktree, s.ID),
		})
	}
	return views
}

// isRootWorktree reports whether a worktree path denotes the catch-all root
// project, which holds sessions started outside any real project.
func isRootWorktree(worktree string) bool {
	return worktree == "/" || worktree == ""
}

// deriveShortName returns the last path component of a worktree, or "Global"
// for the root project.
func deriveShortName(worktree string) string {
	if isRootWorktree(worktree) {
		return "Global"
	}
	return filepath.Base(worktree)
}

// deriveWorkspace returns the path segment following "Workspace", matching
// the ~/Workspace/<workspace>/<project> directory convention used on this
// machine, or "" when the path doesn't follow it.
func deriveWorkspace(worktree string) string {
	segments := strings.Split(strings.Trim(worktree, "/"), "/")
	for i, s := range segments {
		if s == "Workspace" && i+1 < len(segments) {
			return segments[i+1]
		}
	}
	return ""
}

// isActive reports whether a timestamp (Unix milliseconds) lies within the
// last hour.
func isActive(updatedMs int64) bool {
	return time.Since(time.UnixMilli(updatedMs)) < time.Hour
}

// sessionLink returns the OpenCode web UI URL for a session within the given
// project worktree.
func sessionLink(baseURL, worktree, sessionID string) string {
	return baseURL + "/" + base64URLEncode(worktree) + "/session/" + sessionID
}

// projectLink returns the OpenCode web UI URL for a project's session list.
func projectLink(baseURL, worktree string) string {
	return baseURL + "/" + base64URLEncode(worktree) + "/session"
}

// base64URLEncode encodes a string as unpadded URL-safe base64, matching the
// encoding the OpenCode web UI uses for worktree route parameters.
func base64URLEncode(s string) string {
	return base64.RawURLEncoding.EncodeToString([]byte(s))
}
