# NixOS

## Management Commands

To update the inputs of the flake:

- `sudo nix flake update --flake /etc/nixos`
  To switch to a new configuration:
- `sudo nixos-rebuild switch --flake /etc/nixos`

To select the configuration (`quitlox-pi`, `quitlox-homelab`), use:

- `sudo nixos-rebuild switch --flake /etc/nixos#quitlox-homelab`

To update secrets, use (requires key, see `.sops.yaml`):

- `sops nixos/secrets/secrets.yaml`

## Development Environment

To develop these files (even on non-nix systems), it's recommended to
install `Nix` and use `nix profile`.

Install the Language Server and formatter:

- `nix profile add "nixpkgs#nixd"`
- `nix profile add "nixpkgs#nixfmt"`

The `nixd` language server is configured to pick up the first nixos
configuration it finds in the `flake.nix` in the project root.

## Home Networking

Networking Devices

- **Gateway** `Unify Cloud Gateway Fiber` (UCG Fiber)
- **Access Point** `Unify U7 Pro XG`.

## Domain and Hosting

For the hosting of homelab services, I use the domain
`*.home.quitlox.dev`. This domain is registered and configured at Hetzner.

The homelab server runs a traefik reverse proxy listening to port 80 and 443,
rerouting traffic to `*.home.quitlox.dev` to the correct services
(ports). Docker containers can be easily exposed using labels to configure
traefik.

### Configuration

To configure networking:

- Forward ports 80 and 443 to the homelab (requires static IP)
  - Hairpin NAT ensures that traffic originating from the local network sent to
    the WAN IP is bounced back onto the local network. This ensures that the
    domain can be resolved as normal using external DNS, but the server is still
    approached over the local network.
  - If the router/gateway doesn't support Hairpin NAT, a DNS override must be
    configured, either through a rule on the router (if supported), or by hosting
    a custom DNS server on the network.
- Ensure the DNS records (A `home.quitlox.dev`, `*.home.quitlox.dev`) at
  Hetzner point to the WAN IP.
- Ensure the Hetzner API key is valid, such that the ACME challenge can be
  performed to issue SSL certificates.

The `.dev` TLD is a HSTS domain, meaning that it must always be configured
approached using HTTPS.

## TODO

Tasks:

- [ ] Proper security review of configuration
- [ ] Make modules more configurable (domain, ports, hostname, enable)
- [ ] Setup Fail2Ban

Research:

- [ ] Photos: Immich
- [ ] Task Management: Vikunja.io, Tududi, Super-Productivity, HamsterBase Tasks, Donetick, Appflowy
- [ ] Remote Shell: Termix, Apache Guacamole
- [ ] Recipes: ManageMeals, Mealie, Recipya, Tamari
- [ ] Bitwarden: Vaultwarden
- [ ] Google Timeline: Dawarich
- [ ] Authentication: Authelia, Authentik, KeyCloack
- [ ] Podcasts: Audiobookshelf, Podgrab
- [ ] RSS: RSSHub
- [ ] Files: NextCloud
- [ ] Backup: Backblaze
- [ ] Tools: HRConver2, PdfDing, StirlingPDF

Projects:

- Home Assistant
    - [ ] Energy tracking with ESP32 Board via P1 port
    - [ ] Notification: Leaving stovetop unattended
    - [ ] Notification: Leaving roofwindow open (away, wind)
    - [ ] Checklist Notification: tracking out trash, making breakfast
- Server
    - [ ] Log aggregation

Interesting:

- Wanderer -> self-hosted trail database
- Appsmith -> low-code self-hosted application platform

Notes:

- Icons: https://dashboardicons.com/
