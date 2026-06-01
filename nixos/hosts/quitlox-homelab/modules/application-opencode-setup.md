# OpenCode Server — First-time Setup

This document lists everything that must be configured manually as the `opencode`
user after the first `nixos-rebuild switch`. None of this is in the Nix config;
it lives solely on the server.

Log in as the opencode user to run these steps:

```
sudo -u opencode -s
```

---

## 1. Server password

Create the env file that the systemd service loads:

```bash
install -m 600 /dev/null /var/lib/opencode/server.env
echo "OPENCODE_SERVER_PASSWORD=<choose-a-strong-password>" >> /var/lib/opencode/server.env
# Optional: override the username (default is "opencode")
# echo "OPENCODE_SERVER_USERNAME=opencode" >> /var/lib/opencode/server.env
```

Then restart the service:

```bash
sudo systemctl restart opencode-serve
```

---

## 2. AI provider auth

Authenticate opencode with your model provider(s):

```bash
opencode auth login
```

This writes `~/.local/share/opencode/auth.json` (`/var/lib/opencode/.local/share/opencode/auth.json`).

---

## 3. GitHub

```bash
gh auth login
```

Choose HTTPS + browser flow. This also configures the git credential helper so
that `git push/pull` to GitHub repos works without a separate token.

---

## 4. GitLab (work / tno repos)

```bash
glab auth login
```

Choose the appropriate GitLab instance (gitlab.com or your work instance).
This also configures the git credential helper for GitLab HTTPS remotes.

---

## 5. SSH keys (if using SSH remotes)

If any repos use SSH remotes rather than HTTPS:

```bash
ssh-keygen -t ed25519 -C "opencode@quitlox-homelab" -f /var/lib/opencode/.ssh/id_ed25519
cat /var/lib/opencode/.ssh/id_ed25519.pub
```

Register the public key on GitHub (Settings → SSH keys) and/or GitLab
(Preferences → SSH keys), or as a per-repo deploy key.

---

## 6. git identity

Set the identity that will appear on commits made by the agent:

```bash
git config --global user.name "OpenCode (homelab)"
git config --global user.email "<your-email>"
```

---

## 7. Rust toolchain

`rustup` is installed but needs an initial toolchain. Either install stable:

```bash
rustup default stable
```

Or rely on per-project `rust-toolchain.toml` files (rustup will pick these up
automatically when the agent runs `cargo` inside a repo).

---

## 8. Populate Workspace

Clone the repos you want to work on into `/var/lib/opencode/Workspace`:

```bash
cd /var/lib/opencode/Workspace

# Examples
gh repo clone <owner>/<repo> hobby/<repo>
git clone git@github.com:<owner>/<repo>.git contrib/<repo>
```

Each subdirectory will automatically become its own project in opencode with
its own session history.

---

## 9. Verify

From the homelab host:

```bash
curl -u opencode:<password> http://127.0.0.1:4096/global/health
```

From a browser on the LAN or Tailscale:

```
https://opencode.home.quitlox.dev
```

---

## Adding language toolchains

Toolchains are declared in `application-opencode.nix` under
`users.users.opencode.packages` and the service `path`. To add a new language
runtime or tool, edit that list and run `nixos-rebuild switch`.
