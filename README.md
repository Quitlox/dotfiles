# Quitlox's Dotfiles

This repository contains my personal dotfiles. These dotfiles basically contain _all_ my configuration, spanning:

- The `chezmoi` managed dotfiles under `home/`, which contain user configurations for linux applications.
  - These include my ansible configuration in `~/.config/ansible/` automatic the setup of my Arch Linux installations.
- The `nixos` configuration in `nixos/` containing the configurations of my NixOS installations.
  - Currently, these are my homelab server and my (currently-not-in-use) RaspberryPi.

See also:
- [chezmoi dotfiles](./home/README.md)
- [nixos configuration](./nixos/README.md)
