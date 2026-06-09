package opencode

import (
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/quitlox/opencode-glance-extension/internal/model"
)

type Client struct {
	BaseURL    string
	Username   string
	Password   string
	HTTPClient *http.Client
}

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

func (c *Client) doRequest(url string) (*http.Response, error) {
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return nil, fmt.Errorf("creating request: %w", err)
	}
	req.SetBasicAuth(c.Username, c.Password)
	resp, err := c.HTTPClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("executing request: %w", err)
	}
	if resp.StatusCode != http.StatusOK {
		resp.Body.Close()
		return nil, fmt.Errorf("unexpected status %d from %s", resp.StatusCode, url)
	}
	return resp, nil
}

func (c *Client) FetchProjects() ([]model.Project, error) {
	resp, err := c.doRequest(c.BaseURL + "/project")
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	var projects []model.Project
	if err := json.NewDecoder(resp.Body).Decode(&projects); err != nil {
		return nil, fmt.Errorf("decoding projects: %w", err)
	}
	return projects, nil
}

func (c *Client) FetchSessions() ([]model.Session, error) {
	resp, err := c.doRequest(c.BaseURL + "/api/session")
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	var result struct {
		Items []model.Session `json:"items"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, fmt.Errorf("decoding sessions: %w", err)
	}
	return result.Items, nil
}