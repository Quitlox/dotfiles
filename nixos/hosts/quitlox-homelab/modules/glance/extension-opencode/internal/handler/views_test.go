package handler

import "testing"

func TestDeriveWorkspace(t *testing.T) {
	tests := []struct {
		worktree string
		want     string
	}{
		{"/home/quitlox/Workspace/hobby/project", "hobby"},
		{"/home/quitlox/Workspace/tno/deep/nested", "tno"},
		{"/home/quitlox/code/project", ""},
		{"/home/quitlox/Workspace", ""},
		{"/", ""},
		{"", ""},
	}
	for _, tt := range tests {
		if got := deriveWorkspace(tt.worktree); got != tt.want {
			t.Errorf("deriveWorkspace(%q) = %q, want %q", tt.worktree, got, tt.want)
		}
	}
}

func TestDeriveShortName(t *testing.T) {
	tests := []struct {
		worktree string
		want     string
	}{
		{"/home/quitlox/Workspace/hobby/project", "project"},
		{"/", "Global"},
		{"", "Global"},
	}
	for _, tt := range tests {
		if got := deriveShortName(tt.worktree); got != tt.want {
			t.Errorf("deriveShortName(%q) = %q, want %q", tt.worktree, got, tt.want)
		}
	}
}

func TestSessionLink(t *testing.T) {
	// The worktree is base64url-encoded without padding, matching the
	// OpenCode web UI's route parameters.
	got := sessionLink("https://opencode.example.com", "/home/quitlox/project", "ses_123")
	want := "https://opencode.example.com/L2hvbWUvcXVpdGxveC9wcm9qZWN0/session/ses_123"
	if got != want {
		t.Errorf("sessionLink() = %q, want %q", got, want)
	}
}
