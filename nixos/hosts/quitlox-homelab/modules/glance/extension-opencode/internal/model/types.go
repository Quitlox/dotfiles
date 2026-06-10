// Package model defines the data types returned by the OpenCode API.
package model

import (
	"strings"
	"time"
)

// Project represents an OpenCode project from the API.
type Project struct {
	ID       string    `json:"id"`
	Worktree string    `json:"worktree"`
	VCS      string    `json:"vcs,omitempty"`
	Time     Timestamp `json:"time"`
}

// Timestamp holds creation and update timestamps as Unix milliseconds.
type Timestamp struct {
	Created int64 `json:"created"`
	Updated int64 `json:"updated"`
}

// Session represents an OpenCode session from the API.
type Session struct {
	ID        string    `json:"id"`
	ParentID  string    `json:"parentID,omitempty"`
	ProjectID string    `json:"projectID"`
	Agent     string    `json:"agent"`
	Model     Model     `json:"model"`
	Cost      float64   `json:"cost"`
	Tokens    Tokens    `json:"tokens"`
	Time      Timestamp `json:"time"`
	Title     string    `json:"title"`
}

// IsSubagent reports whether the session was spawned by another session's
// task tool rather than started by the user. Subagent sessions carry a
// parentID in OpenCode's session schema; the title check is a fallback in
// case the field is absent from this endpoint's payload, matching titles
// like "Investigate flaky test (@explore subagent)".
func (s Session) IsSubagent() bool {
	if s.ParentID != "" {
		return true
	}
	return strings.HasSuffix(s.Title, " subagent)") && strings.Contains(s.Title, "(@")
}

// IsEmpty reports whether the session has seen no real use: it has no model,
// no token usage, or still carries the auto-generated
// "New session - <RFC3339 timestamp>" title.
func (s Session) IsEmpty() bool {
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
