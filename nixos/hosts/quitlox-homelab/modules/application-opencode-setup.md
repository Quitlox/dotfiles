# OpenCode Server — First-time Setup

1. Log in as the `opencode` user:
   ```bash
   sudo -u opencode -s
   ```
2. Create the `/var/lib/opencode/server.env` file:
   ```bash
   install -m 600 /dev/null /var/lib/opencode/server.env
   echo "OPENCODE_SERVER_PASSWORD=<choose-a-strong-password>" >>/var/lib/opencode/server.env
   # Optional: override the username (default is "opencode")
   # echo "OPENCODE_SERVER_USERNAME=opencode" >> /var/lib/opencode/server.env
   # Then restart:
   sudo systemctl restart opencode-serve
   ```
3. Login to AI provider:
   ```bash
   opencode auth login # auth stored in `/var/lib/opencode/.local/share/opencode.auth.json`
   ```
4. Login to Git forges:
   ```bash
   gh auth login # Choose HTTPS + browser flow
   glab auth login
   ```
5. Generate SSH keys and register to Github / Gitlab
   ```bash
   ssh-keygen -t ed25519 -C "opencode@quitlox-homelab" -f /var/lib/opencode/.ssh/id_ed25519
   cat /var/lib/opencode/.ssh/id_ed25519.pub
   ```
6. Configure Git identity
   ```bash
   git config --global user.name "OpenCode (homelab)"
   git config --global user.email "<your-email>"
   ```
7. \[Optional\] Clone the opencode config repository into `~/.config/opencode`:
   ```bash
   gh repo clone opencode /var/lib/opencode/.config/opencode
   ```

## Healthcheck

From the homelab host:

```bash
curl -u opencode: <password> http://127.0.0.1:4096/global/health
```

## Adding language toolchains

Toolchains are declared in `application-opencode.nix` under
`users.users.opencode.packages` and the service `path`. To add a new language
runtime or tool, edit that list and run `nixos-rebuild switch`.
