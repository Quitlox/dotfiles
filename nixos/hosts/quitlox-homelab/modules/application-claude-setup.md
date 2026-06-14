# Claude Code (remote-control) — First-time Setup

Run as the `opencode` user:

```bash
sudo -u opencode -s
cd /var/lib/opencode
```

1. Authenticate with claude.ai:
   ```bash
   claude        # then run /login
   ```
   NOTE: only subscription login is supported.

2. Accept the workspace-trust dialog for `/var/lib/opencode`. On first `claude`
   launch in this directory, accept the trust prompt, then `/exit`. Or, with
   `claude` not running, set it directly (the file is rewritten on exit, so
   editing it live can be clobbered):

   ```bash
   python3 -c "import json,os;p=os.path.expanduser('~/.claude.json');d=json.load(open(p));d.setdefault('projects',{}).setdefault('/var/lib/opencode',{})['hasTrustDialogAccepted']=True;json.dump(d,open(p,'w'),indent=2)"
   ```

3. Symlink OpenCode configuration into Claude Code.
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

The service reuses the `opencode` user's toolchain via
`/etc/profiles/per-user/opencode/bin`. Add new runtimes/tools in
`application-opencode.nix` under `users.users.opencode.packages` and run
`nixos-rebuild switch` — `claude-serve` picks them up automatically.
