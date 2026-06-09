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
	BaseURL    string
	Username   string
	Password   string
	HTTPClient *http.Client
}

// NewClient creates a Client with basic auth credentials and a default timeout.
func NewClient(baseURL, username, password string) *Client {
	return &Client{
		BaseURL:  baseURL,
		Username: username,
		Password: password,
		HTTPClient: &http.Client{
			Timeout: 30 * time.Second,
		},
	}
}

// FetchProjects retrieves all projects from the OpenCode API.
func (client *Client) FetchProjects() ([]model.Project, error) {
	resp, err := client.doRequest(client.BaseURL + "/project")
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	var projects []model.Project
	err = json.NewDecoder(resp.Body).Decode(&projects)
	if err != nil {
		return nil, fmt.Errorf("decoding projects: %w", err)
	}
	return projects, nil
}

// FetchSessions retrieves all sessions from the OpenCode API.
func (client *Client) FetchSessions() ([]model.Session, error) {
	resp, err := client.doRequest(client.BaseURL + "/api/session")
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	var result struct {
		Items []model.Session `json:"items"`
	}
	err = json.NewDecoder(resp.Body).Decode(&result)
	if err != nil {
		return nil, fmt.Errorf("decoding sessions: %w", err)
	}
	return result.Items, nil
}

var errUnexpectedStatus = errors.New("unexpected HTTP status")

func (client *Client) doRequest(url string) (*http.Response, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, fmt.Errorf("creating request: %w", err)
	}
	req.SetBasicAuth(client.Username, client.Password)

	resp, err := client.HTTPClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("executing request: %w", err)
	}

	if resp.StatusCode != http.StatusOK {
		_ = resp.Body.Close()
		return nil, fmt.Errorf("%w: %d from %s", errUnexpectedStatus, resp.StatusCode, url)
	}
	return resp, nil
}
