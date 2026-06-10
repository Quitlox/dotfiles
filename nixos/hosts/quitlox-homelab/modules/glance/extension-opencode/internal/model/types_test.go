package model

import "testing"

func TestSessionIsSubagent(t *testing.T) {
	tests := []struct {
		name    string
		session Session
		want    bool
	}{
		{
			name:    "title with subagent suffix",
			session: Session{Title: "Investigate flaky test (@explore subagent)"},
			want:    true,
		},
		{
			name:    "parentID set without subagent title",
			session: Session{ParentID: "ses_123", Title: "Investigate flaky test"},
			want:    true,
		},
		{
			name:    "plain user session",
			session: Session{Title: "Fix the build"},
			want:    false,
		},
		{
			name:    "agent mention without subagent suffix",
			session: Session{Title: "Discussing (@explore) output"},
			want:    false,
		},
		{
			name:    "subagent suffix without agent mention",
			session: Session{Title: "Talking about (the subagent)"},
			want:    false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := tt.session.IsSubagent(); got != tt.want {
				t.Errorf("IsSubagent() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestSessionIsEmpty(t *testing.T) {
	used := Tokens{Input: 10, Output: 20}
	tests := []struct {
		name    string
		session Session
		want    bool
	}{
		{
			name:    "no model",
			session: Session{Title: "Fix the build", Tokens: used},
			want:    true,
		},
		{
			name:    "no token usage",
			session: Session{Title: "Fix the build", Model: Model{ID: "anthropic/claude-fable-5"}},
			want:    true,
		},
		{
			name: "auto-generated title",
			session: Session{
				Title:  "New session - 2026-06-10T12:00:00Z",
				Model:  Model{ID: "anthropic/claude-fable-5"},
				Tokens: used,
			},
			want: true,
		},
		{
			name: "user title resembling auto-generated prefix",
			session: Session{
				Title:  "New session - planning notes",
				Model:  Model{ID: "anthropic/claude-fable-5"},
				Tokens: used,
			},
			want: false,
		},
		{
			name: "cache reads count as usage",
			session: Session{
				Title:  "Fix the build",
				Model:  Model{ID: "anthropic/claude-fable-5"},
				Tokens: Tokens{Cache: Cache{Read: 5}},
			},
			want: false,
		},
		{
			name: "used session",
			session: Session{
				Title:  "Fix the build",
				Model:  Model{ID: "anthropic/claude-fable-5"},
				Tokens: used,
			},
			want: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := tt.session.IsEmpty(); got != tt.want {
				t.Errorf("IsEmpty() = %v, want %v", got, tt.want)
			}
		})
	}
}
