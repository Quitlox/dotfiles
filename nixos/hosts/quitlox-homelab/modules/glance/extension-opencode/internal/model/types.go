// Package model defines data types for the OpenCode extension.
package model

import (
	"encoding/base64"
	"path/filepath"
	"strings"
	"time"
)

// Project represents an OpenCode project from the API.
type Project struct {
	ID       string    `json:"id"`
	Worktree string    `json:"worktree"`
	VCS      string    `json:"vcs,omitempty"`
	Time     TimeStamp `json:"time"`
}

// TimeStamp holds creation and update timestamps as Unix milliseconds.
type TimeStamp struct {
	Created int64 `json:"created"`
	Updated int64 `json:"updated"`
}

// Session represents an OpenCode session from the API.
type Session struct {
	ID        string    `json:"id"`
	ProjectID string    `json:"projectID"`
	Agent     string    `json:"agent"`
	Model     Model     `json:"model"`
	Cost      float64   `json:"cost"`
	Tokens    Tokens    `json:"tokens"`
	Time      TimeStamp `json:"time"`
	Title     string    `json:"title"`
}

// IsGlobal reports whether the project is the catch-all root project
// (worktree "/"), which holds sessions started outside any real project.
func (p Project) IsGlobal() bool {
	return p.Worktree == "/" || p.Worktree == ""
}

// IsSubagent reports whether the session is a subagent session.
func (s Session) IsSubagent() bool {
	return strings.HasSuffix(s.Title, " subagent)") && strings.Contains(s.Title, "(@")
}

// Model identifies the LLM used in a session.
type Model struct {
	ID string `json:"id"`
}

// Tokens holds token usage counts.
type Tokens struct {
	Input  int   `json:"input"`
	Output int   `json:"output"`
	Cache  Cache `json:"cache"`
}

// Cache holds cache-related token counts.
type Cache struct {
	Read int `json:"read"`
}

// ProjectView is a merged view of a project with aggregated session data.
type ProjectView struct {
	ID              string
	ShortName       string
	FullPath        string
	Workspace       string
	VCS             string
	SessionCount    int
	TotalCost       float64
	TotalTokens     int64
	LastUpdatedSecs int64
	Active          bool
	Link            string
}

// SessionView is a display-ready representation of a session.
type SessionView struct {
	ID          string
	Title       string
	ModelID     string
	Agent       string
	UpdatedMs   int64
	UpdatedSecs int64
	Active      bool
	Link        string
}

// DeriveShortName returns the last path component of a worktree, or "Global" for root paths.
func DeriveShortName(worktree string) string {
	if worktree == "/" || worktree == "" {
		return "Global"
	}
	return filepath.Base(worktree)
}

// DeriveWorkspace extracts the workspace segment from a worktree path.
func DeriveWorkspace(worktree string) string {
	if worktree == "/" || worktree == "" {
		return ""
	}
	segments := splitPath(worktree)
	for i, s := range segments {
		if s == "Workspace" && i+1 < len(segments) {
			return segments[i+1]
		}
	}
	return ""
}

func splitPath(p string) []string {
	parts := strings.Split(strings.Trim(p, "/"), "/")
	if len(parts) == 1 && parts[0] == "" {
		return nil
	}
	return parts
}

// IsActive reports whether a session updated at the given timestamp is considered recent.
func IsActive(updatedMs int64) bool {
	return time.Since(time.UnixMilli(updatedMs)) < time.Hour
}

// Base64URLEncode encodes a string using URL-safe base64 without padding,
// matching the encoding used by the OpenCode web UI for route parameters.
func Base64URLEncode(s string) string {
	return base64.RawURLEncoding.EncodeToString([]byte(s))
}

// SessionLink returns the OpenCode web UI URL for a session within the given project worktree.
func SessionLink(baseURL, worktree, sessionID string) string {
	return baseURL + "/" + Base64URLEncode(worktree) + "/session/" + sessionID
}

// ProjectLink returns the OpenCode web UI URL for a project's session list.
func ProjectLink(baseURL, worktree string) string {
	return baseURL + "/" + Base64URLEncode(worktree) + "/session"
}

// IsEmptySession reports whether a session should be hidden from the widget:
// it has no model, no token usage, or still carries the auto-generated
// "New session - <timestamp>" title.
func IsEmptySession(s Session) bool {
	if s.Model.ID == "" {
		return true
	}
	if s.Tokens.Input == 0 && s.Tokens.Output == 0 && s.Tokens.Cache.Read == 0 {
		return true
	}
	if rest, ok := strings.CutPrefix(s.Title, "New session - "); ok {
		if _, err := time.Parse(time.RFC3339, rest); err == nil {
			return true
		}
	}
	return false
}
