# Dotfiles

## Configurations

Notable configurations include:
- `~/.config/nvim`: Lua-based Neovim configuration
- `~/.config/hyprland`: Hyprland - a Wayland compositor - configuration
- `~./config/zsh`: Zsh configuration

## Chezmoi

Chezmoi is a dotfiles manager. It uses a *source state* (in
`~/.local/share/chezmoi`) and a *target state*. The *source state* is committed
to version control. When running `chezmoi apply`, the *source state* is used to
produce the *target state*.

### Cheatsheet

Initialize from scratch with `chezmoi init quitlox` 

> This command clones the public repository `quitlox/dotfiles` to
> `~/.local/share/chezmoi`.

Use `chezmoi status` to get a list of modified files (both
directions) and use `chezmoi diff` to see the differences between the
source and target state.

Add or update a new file to the source state using `chezmoi add ...`. Common
flags are the following:
- `--exact` to indicate that the target folder should match the contents of the
source folder exactly. In the source folder exact folders are prefixed with
`exact_`.

Files in the source state can be templated by appending the `.tmpl` extension
(or by using `--template` upon `chezmoi add`). These templates are processed
with Go templates.

## Cross-Machine Setup

This configuration is used on multiple devices simultaneously. Not every
machine has identical configuration. 

Most importantly, the `.chezmoiignore` file is used to determine which files
are required on which systems. Notably, windows and Linux machines need vastly
different subsets of the configuration files. The next main differentiator is
whether the system is headless or not.

## Secrets

Some files contain secrets, and thus are encrypted. This is supported by
`chezmoi` using the `--encrypt` flag when adding files. Files are encrypted
using `age` with the private key `~/.ssh/.age_private_key.txt`. This key is
obviously not stored in the repository but can be retrieved from the secrets
manager using the `scripts/install_age_key.bash` or
`scripts/install_age_key.ps1` scripts.

For secrets using in configuration files, these are substituted using the
template functionality of chezmoi. The `rbw` Bitwarden client is used as
a secrets manager.
