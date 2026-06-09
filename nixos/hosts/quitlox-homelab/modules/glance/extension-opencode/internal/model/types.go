// Package model defines data types for the OpenCode extension.
package model

import (
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