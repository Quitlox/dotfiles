// Package opencode provides an HTTP client for the OpenCode API.
package opencode

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"time"

	"github.com/quitlox/glance-extension-opencode/internal/model"
)

// Client communicates with the OpenCode API.
type Client struct {
	baseURL    string
	username   string
	password   string
	httpClient *http.Client
}

// NewClient creates a Client with basic auth credentials and a default timeout.
func NewClient(baseURL, username, password string) *Client {
	return &Client{
		baseURL:  baseURL,
		username: username,
		password: password,
		httpClient: &http.Client{
			Timeout: 30 * time.Second,
		},
	}
}

// FetchProjects retrieves all projects. Unlike sessions, the projects
// endpoint lives at the server root and returns a bare JSON array.
func (c *Client) FetchProjects(ctx context.Context) ([]model.Project, error) {
	var projects []model.Project
	if err := c.fetchJSON(ctx, c.baseURL+"/project", &projects); err != nil {
		return nil, fmt.Errorf("fetching projects: %w", err)
	}
	return projects, nil
}

// FetchSessions retrieves all sessions. The sessions endpoint belongs to the
// web UI API and wraps its results in an "items" envelope.
func (c *Client) FetchSessions(ctx context.Context) ([]model.Session, error) {
	var result struct {
		Items []model.Session `json:"items"`
	}
	if err := c.fetchJSON(ctx, c.baseURL+"/api/session", &result); err != nil {
		return nil, fmt.Errorf("fetching sessions: %w", err)
	}
	return result.Items, nil
}

var errUnexpectedStatus = errors.New("unexpected HTTP status")

// fetchJSON GETs url and decodes the JSON response into v. The body is fully
// decoded before returning, so ctx (typically the incoming request's context)
// safely covers the entire exchange.
func (c *Client) fetchJSON(ctx context.Context, url string, v any) error {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return fmt.Errorf("creating request: %w", err)
	}
	req.SetBasicAuth(c.username, c.password)

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return fmt.Errorf("executing request: %w", err)
	}
	defer func() { _ = resp.Body.Close() }()

	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("%w: %d from %s", errUnexpectedStatus, resp.StatusCode, url)
	}
	if err := json.NewDecoder(resp.Body).Decode(v); err != nil {
		return fmt.Errorf("decoding response: %w", err)
	}
	return nil
}
