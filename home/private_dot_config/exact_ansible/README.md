
## Setup Ansible (Controller / Local Only)

To install the required roles, run the following commands:

```bash
sudo ansible-galaxy install -r requirements.yml -p /usr/local/share/ansible/roles
sudo ansible-galaxy collection install -r requirements.yml -p /usr/local/share/ansible/roles
```

> [!WARNING] > `/usr/local/share` is not included in the default paths of ansible (`/usr/share/ansible` is).
> Therefore, `ansible.cfg` modifies the defaults paths.

## Locally Configure a New Host

### Archinstall

1. **Boot**: Insert the Arch boot device and boot into the live environment.
1. **Install Arch**: Run `archinstall` and follow the instructions.
   1. Set the mirror region
   1. Set the parition layout
   1. Set the root password
   1. Add `quitlox` user with password and root privileges
   1. Set installation type to `minimal`
   1. Set network configuration to `NetworkManager`
   1. Additional packages: `git`, `rbw`, `chemzoi`, `ansible`
   1. TODO: Move this configuration file to my USB
1. **Setup Bitwarden**
   1. `rbw config set email kevin.witlox@upcmail.nl`
   1. `rbw login`
1. **Setup dotfiles**
   1. `chezmoi init quitlox --apply`
1. **Setup system using Ansible**
   1. `cd ~/.config/ansible`
   1. `sudo ansible-galaxy install -r requirements.yml -p /usr/local/share/ansible/roles`
   1. `sudo ansible-galaxy collection install -r requirements.yml -p /usr/local/share/ansible/roles`
   1. `ansible-playbook -u quitlox -l localhost -K p-install-arch-base.yml`
      - substitute `localhost` with `vm` or another name matching inventory (to load corresponding variables in `./host_vars/`)

## Remotely Configure a New Host

### Prepare the New Host

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

### Run Playbook

- `ansible-playbook maintenance-dotfiles.yml -u quitlox -l '<host>' -K`
  - Installs the dotfiles repository on the target host.

> [!NOTE] Starship
> You may need to restart in order for starship to be able to load.

### Install Dotfiles

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

## Post Installation

### Applications

1. Install Hyprland Plugins and update plugin manager
   1. `hyprpm update`
   1. `hyprpm add http://github.com/outfoxxed/hy3`
   1. `hyprpm enable hy3`
   1. Restart
1. Log into Zotero and enable synchronization
   1. Install the Zotero browser connector
1. Log into Obsidian and synchronize the vault
1. Log into Thunderbird

## Setting up a Virtual Machine

This section is dedicated to configuring a Virtual Machine to run my Arch
Linux desktop configuration. These steps were tested on my work laptop, which
may have some limitations. 

1. Create a new VM in VirtualBox
   - Use the following settings:
         - Enable Hardware Acceleration (*required* for Hyprland)
         - Graphics Controller: VMSVGA is recommended and more stable, but guest additions only seem to work on VBoxSVGA.
         - DO NOT: Change the virtualisation type (leave default)
         - DO NOT: Check EFI (should work, but doesn't seem to)
         - NOTE: It seems that the VM requires focus / keyboard input to boot

## TODO

- Desktop:
   - Wacom Tablet:
         - see: /etc/udev/rules.d/99-wacom.rules)
         - ~/.config/systemd/wacom.service
   - OpenVPN / DNS
- Improvements:
   - Make abstract role for adding hooks to initramfs
   - Automatically set governor to ondemand/performance for lenovo based on
   charging state via udev events

## Security

Security Issues:
- SSHD Port is custom but fixed and publicly readable.

## Memorandum

- Example `fstab` entry for mounting network drivers:
   * ```bash /etc/fstab
      root@162.55.47.225:/mnt/data /mnt/data fuse.sshfs noauto,x-systemd.automount,_netdev,user,idmap=user,follow_symlinks,identityfile=/home/quitlox/.ssh/key_hetzner,allow_other,default_permissions,uid=1000,gid=1000,entry_timeout=1800,attr_timeout=1800,reconnect 0 0
      ```
   * `_netdev` => wait for network
     `allow_other` => allow other users to use the filesystem (other than root)

