#!/bin/bash

rm /etc/apt/sources.list.d/pve-enterprise.list
echo "# Proxmox Test" >> /etc/apt/sources.list
echo "deb http://download.proxmox.com/debian/pve buster pvetest" >> /etc/apt/sources.list
sleep 1
apt update && apt full-upgrade -y
sleep 1
# Installation et configuration de fail2ban
apt install fail2ban -y
sleep 2
echo "
# ne pas éditer /etc/fail2ban/jail.conf

[DEFAULT]
destemail = danielitto91@gmail.com
sender = root@example.lan
ignoreip = 127.0.0.1/8 192.168.56.105 192.168.56.106 192.168.56.107

[sshd]
enabled = true
port = 22
maxretry = 10
findtime = 120
bantime = 1200
logpath = /var/log/auth.log

[sshd-ddos]
enabled = true

[recidive]
enabled = true
" > /etc/fail2ban/jail.d/defaults-debian.conf
sleep 2
systemctl restart fail2ban

# Installation de Molly-guard
apt install molly-guard -y

# Installation de Rkhunter
apt install rkhunter -y

# Installation de Mlocate
apt install mlocate -y

# Installation de vim
apt install vim -y

# Installation de net-tools
apt install net-tools -y

# Installation de at
apt install at -y
sleep 2

# Purge de l'ancien Kernel
apt purge pve-kernel-5.0.15-1-pve -y | at now + 6 minutes
sleep 2

# redémarrage
reboot
