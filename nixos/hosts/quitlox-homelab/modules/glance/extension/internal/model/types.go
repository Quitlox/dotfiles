package model

import (
	"path/filepath"
	"strings"
	"time"
)

type Project struct {
	ID       string    `json:"id"`
	Worktree string    `json:"worktree"`
	VCS      string    `json:"vcs,omitempty"`
	Time     TimeStamp `json:"time"`
}

type TimeStamp struct {
	Created int64 `json:"created"`
	Updated int64 `json:"updated"`
}

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

type Model struct {
	ID string `json:"id"`
}

type Tokens struct {
	Input  int   `json:"input"`
	Output int   `json:"output"`
	Cache  Cache `json:"cache"`
}

type Cache struct {
	Read int `json:"read"`
}

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

type SessionView struct {
	ID          string
	Title       string
	ModelID     string
	Agent       string
	UpdatedMs   int64
	UpdatedSecs int64
	Active      bool
}

func DeriveShortName(worktree string) string {
	if worktree == "/" || worktree == "" {
		return "Global"
	}
	return filepath.Base(worktree)
}

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

func IsActive(updatedMs int64) bool {
	return time.Since(time.UnixMilli(updatedMs)) < time.Hour
}