## Install

To install the required roles, run the following commands:

```bash
sudo ansible-galaxy install -r requirements.yml -p /usr/local/share/ansible/roles
sudo ansible-galaxy collection install -r requirements.yml -p /usr/local/share/ansible/roles
```

> [!WARNING]
> `/usr/local/share` is not included in the default paths of ansible (`/usr/share/ansible` is).
> Therefore, `ansible.cfg` modifies the defaults paths.

## Setting up a host

A few manual steps need to be performed before managing a linux host:
1. Setup networking
    - If LAN is available, `systemctl enable --now NetworkManager.service`
      should suffice.
1. Install and enable ssh
    - `pacman -Syu openssh`
    - `systemctl enable --now sshd.service`
1. Create a user account
    - `useradd -m -G wheel quitlox`
1. Give sudo permissions to new user
    - `pacman -Syu sudo vi`
    - Using `visudo`, uncomment the line `% WHEEL ...`
1. From the controller, copy over the ssh key
    - `ssh-copy-id -i ~/.ssh/key_quitlox quitlox@192.168.2.x`

Now you're good to go.

## Playbooks

- `ansible-playbook maintenance-dotfiles.yml -u quitlox -l '<host>' -K`
    - Installs the dotfiles repository on the target host.
    - Note: You may need to restart in order for starship to be able to load.

## Post Installation

To setup dotfiles:
1. Install requirements
    - `sudo pacman -Syu bitwarden-cli chemzoi`
1. Log-in to Bitwarden
    - `bw login`
1. Retrieve decryption key
    ```bash
    bw get item "ChezMoi Dotfiles Manager" | jq ".fields[1].value" | tr -d \" > ~/.ssh/.age_private_key.txt
    ```
1. Place dotfiles
    - `chezmoi init quitlox --apply`
1. Change repo to ssh
    - `git remote set-url origin git@github.com:quitlox/dotfiles`

## TODO

/etc/udev/rules.d/99-wacom.rules
~/.config/systemd
- Atuin: Server out of sync and misconfigured
STARSHIP

- Make abstract role for adding hook to initramfs
- Configure swap using swap partition

- Zotero
    - Log into Zotero automatically and setup sync?
    - Install Zotero browser connector automatically?
    - Zotero Marketplace
    - Zotero better bibtex
    - Zotero obsidian integration
- Log into Obsidian automatically?
- Configure thunderbird

## Security

Security Issues:
- SSHD Port is custom but fixed and publicly readable.
