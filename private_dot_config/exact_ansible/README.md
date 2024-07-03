## Install

To install the required roles, run the following command:

```bash
ansible-galaxy install -r requirements.yml -p /usr/share/ansible/roles
```

## Playbooks

- `ansible-playbook maintenance-dotfiles.yml -l '<host>'`
    - Installs the dotfiles repository on the target host.

## TODO

/etc/udev/rules.d/99-wacom.rules
~/.config/systemd
- Atuin: Server out of sync and misconfigured
