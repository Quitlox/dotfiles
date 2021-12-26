
# Setup Hetzner Server

## Step 1: Dotfiles

Clone and configure the dotfiles using the bootstrap.sh script

## Step 2: Data Volume

**Mount the Volume**
Instruction can be found in the Hetzner Cloud console
**Setup Permission**

1. Add a "data" usergroup
2. Change the group of the data mount:
   `chgrp data /mnt/data`
3. Set sticky bit for group inheritance:
   `chmod g+s /mnt/data`

## Setup Atuin

1. Install Postgres
   `sudo apt install postgresql postgresql-client postgresql-doc phppgadmin`
2. Start Postgres
   `sudo systemctl enable --now postgresql`
3. Add `atuin` linux user
   `adduser --no-create-home atuin` (use bitwarden 'Atuin: Debian User')
4. Setup Postgres
   `sudo su postgres`
   `createuser --pwprompt atuin` (use bitwarden 'Atuin: Postgresql User')
   `createdb -O atuin atuindb`
5. Install Docker (see OceanDigital tutorial)
6. Enable forwarding
   `sudo sysctl net.ipv4.conf.all.forwarding=1`
   `sudo iptables -P FORWARD ACCEPT`
7. Start the Atuin Systemd service

