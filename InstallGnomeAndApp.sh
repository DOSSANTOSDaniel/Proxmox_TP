#!/bin/bash

# variables
ipnet=$(hostname -I | awk '{print $1}')
ipwifi=$(hostname -I | awk '{print $2}')
usertos=$(w | awk '{print $1}' | awk 'NR==3')

apt update && apt dist-upgrade -y

#Make sure network-manager is not used, else pve-cluster will not start in some cases
apt remove network-manager --purge

# Installation de Gnome3
#apt install task-gnome-desktop -y

# Install mate
apt-get install xorg -y
apt-get install lightdm -y
apt-get install mate-desktop-environment -y

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
apt install synaptic apt-xapian-index -y

# Pilote ATI
apt install libgl1-mesa-dri xserver-xorg-video-ati -y

# install the headers and nvidia-drivers
apt install pve-headers -y
apt-get update 
apt-get install nvidia-driver -y

# Pilote Radeon
apt install libgl1-mesa-dri xserver-xorg-video-radeon -y

# installateur .deb
apt install gdebi -y

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
ignoreip = 127.0.0.1/8 $ipnet $ipwifi
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

#Optional: Remove the Debian kernel
#apt-get remove linux-image-amd64 linux-image-3.16.0-4-amd64 linux-base

# mise à jour grub
update-grub

# nettoyage du système
apt-get autoremove --purge
apt-get autoclean --purge
rm -Rf ~/.local/share/Trash/*
rm -Rf /root/.local/share/Trash/*
rm -Rf ~/.thumbnails

# Purge de l'ancien Kernel
apt purge pve-kernel-5.0.15-1-pve -y | at now + 6 minutes
sleep 2

# redémarrage
systemctl reboot
