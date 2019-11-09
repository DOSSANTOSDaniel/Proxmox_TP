#!/bin/bash

# variables
ipnet=$(hostname -I | awk '{print $1}')
ipwifi=$(hostname -I | awk '{print $2}')
routetos=$(ip route | grep '^default via' | awk '{print $3}')
interfacewifi=$(ip link | grep ^3 | awk '{print $2}' | sed s'/://')
interfacenet=$(ip link | grep ^2 | awk '{print $2}' | sed s'/://')
usertos=$(w | awk '{print $1}' | awk 'NR==3')

apt update && apt dist-upgrade -y

# Installation de Gnome3
apt install task-gnome-desktop -y

# optimisation pour laptop
tasksel install laptop

# démarrage automatique du server sur Gnome
systemctl set-default graphical.target

# installation de simplenote
wget https://github.com/Automattic/simplenote-electron/releases/download/v1.10.0/Simplenote-linux-1.10.0-amd64.deb
apt install gconf2 -y
dpkg -i Simplenote-linux-1.10.0-amd64.deb
sleep 1
rm Simplenote-linux-1.10.0-amd64.deb

# installation de etcher
echo "deb https://dl.bintray.com/resin-io/debian stable etcher" | tee /etc/apt/sources.list.d/etcher.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
apt update
apt install etcher-electron -y

# installation et configuration de sudo
apt install sudo -y
usermod -aG sudo $usertos

# install vim
apt install vim -y

# install vlc
apt install vlc -y

# install filezilla
apt install filezilla -y

# installation et configuration du firewall
apt install ufw -y
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 80
ufw allow 443
ufw allow 8006
ufw enable -y
ufw status

# installation de microapplications tierces
apt install firmware-linux firmware-linux-nonfree libdrm-amdgpu1 xserver-xorg-video-amdgpu -y

# appstore synaptic
apt install synaptic apt-xapian-index

# Pilote ATI
apt install libgl1-mesa-dri xserver-xorg-video-ati

# Pilote Radeon
apt install libgl1-mesa-dri xserver-xorg-video-radeon

# installateur .deb
apt update && apt install gdebi

#  Enlever la bannière de subscription
cp /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js.save
sed -i "s/data.status !== 'Active'/false/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
sleep 1
systemctl restart pveproxy.service

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
sleep 1
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

# mise à jour grub


# nettoyage du système
apt-get autoremove --purge
apt-get clean
rm -Rf ~/.local/share/Trash/*
rm -Rf /root/.local/share/Trash/*
rm -Rf ~/.thumbnails

# Purge de l'ancien Kernel
apt purge pve-kernel-5.0.15-1-pve -y | at now + 6 minutes
sleep 2

# redémarrage
reboot
