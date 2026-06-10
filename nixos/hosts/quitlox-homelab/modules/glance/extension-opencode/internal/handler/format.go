package handler

import (
	"fmt"
	"strconv"
	"strings"
)

// FormatCost renders a dollar amount with two decimals, showing "<$0.01" for
// tiny non-zero amounts.
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

// FormatTokens abbreviates a token count, e.g. 1500 -> "1.5k", 2000000 -> "2M".
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

// WorkspaceLabel maps workspace directory names (see deriveWorkspace) to
// friendlier display labels, passing unknown names through unchanged.
func WorkspaceLabel(ws string) string {
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

// ShortenModel strips the provider prefix from a model ID, e.g.
// "anthropic/claude-fable-5" -> "claude-fable-5".
func ShortenModel(id string) string {
	parts := strings.Split(id, "/")
	return parts[len(parts)-1]
}
