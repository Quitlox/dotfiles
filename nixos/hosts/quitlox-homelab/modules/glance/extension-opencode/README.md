# glance-extension-opencode

A [Glance](https://github.com/glanceapp/glance) extension widget that shows
[OpenCode](https://opencode.ai) activity: recent sessions and per-project
cost/token aggregates, with links into the OpenCode web UI.

## Endpoints

| Path        | Description                                                  |
| ----------- | ------------------------------------------------------------ |
| `/sessions` | Recent user-started sessions (subagent sessions filtered out) |
| `/projects` | Projects with session count, total cost, and token usage      |
| `/healthz`  | Health check, always returns 200                              |

Both widget endpoints set the `Widget-Title` and `Widget-Content-Type`
headers Glance expects from an `extension` widget.

## Configuration

All configuration is via environment variables:

| Variable               | Required | Default                              | Description                                      |
| ---------------------- | -------- | ------------------------------------ | ------------------------------------------------ |
| `OPENCODE_USERNAME`    | yes      |                                      | Basic auth username for the OpenCode API         |
| `OPENCODE_PASSWORD`    | yes      |                                      | Basic auth password for the OpenCode API         |
| `OPENCODE_BASE_URL`    | no       | `https://opencode.home.quitlox.dev`  | OpenCode API to fetch sessions and projects from |
| `OPENCODE_EXTERNAL_URL`| no       | `https://opencode.home.quitlox.dev`  | OpenCode web UI base for links in the widget     |
| `PORT`                 | no       | `8080`                               | Port to listen on                                |

## Development

```sh
go test ./...
golangci-lint run ./...
```

## Deployment

Deployed by `../../application-glance-extension-opencode.nix`, which builds
the binary with `pkgs.buildGoModule` (running the tests in the process),
packages it with `pkgs.dockerTools.buildImage`, and runs it as a sidecar in
the glance arion project.
