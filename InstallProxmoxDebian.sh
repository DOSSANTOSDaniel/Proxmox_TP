#!/bin/bash

# Description:
#	Permet l'installation de Proxmox sur Debian Buster (10)
#----------------------------------------------------------------#
# Usage: ./InstallProxmoxDebian.sh
#	Exécuter le script en root!
#   Se connecter en root avec cette commande "su -" !
#   Durée: ~ 6 minutes
#
# Campatibilité:
#	Il est préférable de ne pas être connecté en Wifi.
# Auteur:
#  	Daniel DOS SANTOS < daniel.massy91@gmail.com >
#----------------------------------------------------------------#


apt update && apt full-upgrade -y

apt install gnupg -y

hostnamectl set-hostname pve1.proxmox.lan --static

usertos=$(w | awk '{print $1}' | awk 'NR==3')
ipnet=$(hostname -I | awk '{print $1}')
ipwifi=$(hostname -I | awk '{print $2}')
routetos=$(ip route | grep '^default via' | awk '{print $3}')
interfacewifi=$(ip link | grep ^3 | awk '{print $2}' | sed s'/://')
interfacenet=$(ip link | grep ^2 | awk '{print $2}' | sed s'/://')

# Fonctions
reseauip()
{
      echo "
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo $interfacenet
iface lo inet loopback

# The primary network interface
allow-hotplug $interfacenet
iface $interfacenet inet static
    address $ipnet/24
    gateway $routetos
    nameserver 8.8.8.8
" > /etc/network/interfaces
echo $ipnet "pve1.proxmox.lan pve1" |  tee -a /etc/hosts
}

while [ : ]
do
echo ""
read -p "Quelle type de connexion ? Wifi[w] ou Câble[c] : " typecon
echo ""

if [ $typecon == "c" ]
then
reseauip()
echo $ipnet "pve1.proxmox.lan pve1" |  tee -a /etc/hosts
breack
elif [ $typecon == "w" ]
then
reseauip()
echo "    
# 2 interface wifi
iface $interfacewifi inet static
    address $ipwifi/24
    gateway $routetos
    nameservers 8.8.8.8
" > /etc/network/interfaces
echo $ipwifi "pve1.proxmox.lan pve1" |  tee -a /etc/hosts
breack
else
    echo " Erreur syntax essayez de nouveau !"
fi
done

wget -qO - http://download.proxmox.com/debian/proxmox-ve-release-6.x.gpg | apt-key add -
echo "deb http://download.proxmox.com/debian/pve buster pvetest" |  tee /etc/apt/sources.list.d/pve-install-repo.list
echo "deb http://download.proxmox.com/debian/ceph-nautilus buster main" |  tee /etc/apt/sources.list.d/ceph.list
sleep 1

apt update && apt dist-upgrade -y

apt install proxmox-ve -y
rm /etc/apt/sources.list.d/pve-enterprise.list

systemctl reboot
