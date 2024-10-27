## Install

To install the required roles, run the following commands:

```bash
ansible-galaxy install -r requirements.yml -p /usr/local/share/ansible/roles
ansible-galaxy collection install -r requirements.yml -p /usr/local/share/ansible/roles
```

> [!WARNING]
> `/usr/local/share` is not included in the default paths of ansible (`/usr/share/ansible` is).
> Therefore, `ansible.cfg` modifies the defaults paths.

## Playbooks

- `ansible-playbook maintenance-dotfiles.yml -l '<host>'`
    - Installs the dotfiles repository on the target host.
    - Note: You may need to restart in order for starship to be able to load.

## TODO

/etc/udev/rules.d/99-wacom.rules
~/.config/systemd
- Atuin: Server out of sync and misconfigured
- chezmoi repo set to ssh
STARSHIP

- Make abstract role for adding hook to initramfs
- Configure swap using swap partition

- Hyprland
    - dependencies: socat (used in eww scripts)

- Bitwarden:
    - Get chezmoi decryption key using: 
    ```bash
    bw get item "ChezMoi Dotfiles Manager" | jq ".fields[1].value" > ~/.ssh/.age_private_key.txt
    ```
