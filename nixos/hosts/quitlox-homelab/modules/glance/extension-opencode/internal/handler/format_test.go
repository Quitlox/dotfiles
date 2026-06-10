package handler

import "testing"

func TestFormatCost(t *testing.T) {
	tests := []struct {
		cost float64
		want string
	}{
		{0, "$0.00"},
		{0.005, "<$0.01"},
		{0.01, "$0.01"},
		{1.234, "$1.23"},
	}
	for _, tt := range tests {
		if got := FormatCost(tt.cost); got != tt.want {
			t.Errorf("FormatCost(%v) = %q, want %q", tt.cost, got, tt.want)
		}
	}
}

func TestFormatTokens(t *testing.T) {
	tests := []struct {
		tokens int64
		want   string
	}{
		{0, "0"},
		{999, "999"},
		{1_000, "1k"},
		{1_500, "1.5k"},
		{1_000_000, "1M"},
		{2_500_000, "2.5M"},
	}
	for _, tt := range tests {
		if got := FormatTokens(tt.tokens); got != tt.want {
			t.Errorf("FormatTokens(%d) = %q, want %q", tt.tokens, got, tt.want)
		}
	}
}

func TestShortenModel(t *testing.T) {
	tests := []struct {
		id   string
		want string
	}{
		{"anthropic/claude-fable-5", "claude-fable-5"},
		{"claude-fable-5", "claude-fable-5"},
	}
	for _, tt := range tests {
		if got := ShortenModel(tt.id); got != tt.want {
			t.Errorf("ShortenModel(%q) = %q, want %q", tt.id, got, tt.want)
		}
	}
}
