#!/bin/bash

apt update && apt dist-upgrade -y

apt install gnupg -y

usertos=$(w | awk '{print $1}' | awk 'NR==3')

hostnamectl set-hostname pve1.proxmox.lan --static
 
ipnet=$(hostname -I | awk '{print $1}')
ipwifi=$(hostname -I | awk '{print $2}')
routetos=$(ip route | grep '^default via' | awk '{print $3}')
interfacewifi=$(ip link | grep ^3 | awk '{print $2}' | sed s'/://')
interfacenet=$(ip link | grep ^2 | awk '{print $2}' | sed s'/://')

echo ""
read -p "Quelle type de connexion ? Wifi[w] ou Câble[c] : " typecon
echo ""

if [ $typecon == "c" ]
then
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
elif [ $typecon == "w" ]
then
echo "
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo $interfacenet $interfacewifi
iface lo inet loopback

# The primary network interface
allow-hotplug $interfacenet
iface $interfacenet inet static
    address $ipnet/24
    gateway $routetos
    nameserver 8.8.8.8
    
# 2 interface wifi
iface $interfacewifi inet static
    address $ipwifi/24
    gateway $routetos
    nameservers 8.8.8.8
" > /etc/network/interfaces

echo $ipwifi "pve1.proxmox.lan pve1" |  tee -a /etc/hosts
else
    echo " Erreur syntax redémarrer le script"
    exit 1
fi

wget -qO - http://download.proxmox.com/debian/proxmox-ve-release-6.x.gpg | apt-key add -

echo "deb http://download.proxmox.com/debian/pve buster pvetest" |  tee /etc/apt/sources.list.d/pve-install-repo.list
echo "deb http://download.proxmox.com/debian/ceph-nautilus buster main" |  tee /etc/apt/sources.list.d/ceph.list
sleep 1

apt update && apt dist-upgrade -y

apt install proxmox-ve postfix open-iscsi -y

rm /etc/apt/sources.list.d/pve-enterprise.list

reboot
