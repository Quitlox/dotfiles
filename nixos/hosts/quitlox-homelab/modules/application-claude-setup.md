# Claude Code (remote-control) — First-time Setup

Run as the `code` user:

```bash
sudo -u code -s
cd /var/lib/code
```

1. Authenticate with claude.ai:
   ```bash
   claude        # then run /login
   ```
   NOTE: only subscription login is supported.

2. Symlink OpenCode configuration into Claude Code.
   ```bash
   ln -sf ~/.config/opencode/AGENTS.md ~/.claude/CLAUDE.md
   ln -sf ~/.config/opencode/skills    ~/.claude/skills
   ```

## Healthcheck

```bash
systemctl status claude-serve
journalctl -u claude-serve -n 50    # should show a registered claude.ai/code session
```

## Adding language toolchains

The service reuses the `code` user's toolchain via
`/etc/profiles/per-user/code/bin`. Add new runtimes/tools in
`application-opencode.nix` under `users.users.code.packages` and run
`nixos-rebuild switch` — `claude-serve` picks them up automatically.
