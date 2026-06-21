# fail2ban - Ban IPs that fail authentication
#
# The NixOS module auto-enables a default `sshd` jail when openssh is enabled,
# and sets `LogLevel = VERBOSE` on sshd so failed login attempts are observable
# from the journal (the default backend is `systemd`).
#
# The local LAN subnet is whitelisted via `quitlox.traefik.lan.subnet` so that
# logins from the home network never trigger a ban.
{ config, lib, ... }:
{
  services.fail2ban = {
    enable = true;
    bantime = "1h";
    maxretry = 5;
    bantime-increment.enable = true;
    ignoreIP = [
      "127.0.0.1/8"
    ] ++ lib.optional (config.quitlox.traefik.lan.subnet != null) config.quitlox.traefik.lan.subnet;
  };
}
