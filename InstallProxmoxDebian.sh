#!/bin/bash

# Description:
#	Permet l'installation de Proxmox sur Debian Buster (10)
#----------------------------------------------------------------#
# Usage: ./InstallProxmoxDebian.sh
#	Exécuter le script en root!
#   Se connecter en root avec cette commande "su -" !
#   Durée: ~ 6 minutes
#
# Auteur:
#  	Daniel DOS SANTOS < daniel.massy91@gmail.com >
#
# Sources:
# https://pve.proxmox.com/wiki/Install_Proxmox_VE_on_Debian_Buster
# https://computingforgeeks.com/how-to-install-proxmox-ve-on-debian/
# https://pve.proxmox.com/wiki/Developer_Workstations_with_Proxmox_VE_and_X11
# 
#----------------------------------------------------------------#

apt update && apt full-upgrade -y

apt install gnupg -qqy

hostnamectl set-hostname pve.proxmox.lan --static

interfacenet=$(ip link | grep ^2 | awk '{print $2}' | sed s'/://')
ipnet=$(hostname -I | awk '{print $1}')
routetos=$(ip route | grep '^default via' | awk '{print $3}')

echo "
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto $interfacenet
allow-hotplug $interfacenet
iface $interfacenet inet manual

auto vmbr0
iface vmbr0 inet static
        address  $ipnet/24
        gateway  $routetos
        bridge_ports enp2s0
        bridge_stp off
        bridge_fd 0

" > /etc/network/interfaces

echo "$ipnet pve.proxmox.lan pve" |  tee -a /etc/hosts

hostname --ip-address

wget -qO - http://download.proxmox.com/debian/proxmox-ve-release-6.x.gpg | apt-key add -
echo "deb [arch=amd64] http://download.proxmox.com/debian/pve buster pvetest" |  tee /etc/apt/sources.list.d/pve-install-repo.list

# Il s’agit du dépôt Ceph pour Proxmox VE
echo "deb http://download.proxmox.com/debian/ceph-nautilus buster main" |  tee /etc/apt/sources.list.d/ceph.list
sleep 1

apt update && apt full-upgrade -y

# Effacer les paquets non utilisés
apt purge -qqy firmware-bnx2x
apt purge -qqy firmware-realtek 
apt purge -qqy firmware-linux
apt purge -qqy firmware-linux-free 
apt purge -qqy firmware-linux-nonfree

apt install proxmox-ve -y

# Si vous avez déjà un serveur Postfix alors choisir: système satellite si non choisir: local uniquement
apt install postfix -y
apt install open-iscsi -y
rm /etc/apt/sources.list.d/pve-enterprise.list

# Seulement si on est pas en dual boot !
apt remove os-prober -y

update-grub

systemctl reboot
