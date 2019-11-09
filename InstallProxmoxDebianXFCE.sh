#!/bin/bash

#TP Proxmox on Debian
#----------------------------
#https://computingforgeeks.com/how-to-install-proxmox-ve-on-debian/
#https://pve.proxmox.com/wiki/Package_Repositories#_proxmox_ve_test_repository    

apt update && apt dist-upgrade -y

echo "PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin" >> /home/daniel/.bashrc
sleep 1
source /home/daniel/.bashrc

echo "PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin" >> /root/.bashrc
sleep 1 
source /root/.bashrc

hostnamectl set-hostname pve1.proxmox.lan --static
 
iptos=$(hostname -I)

echo $iptos"pve1.proxmox.lan pve1" |  tee -a /etc/hosts

apt install gnupg -y

wget -qO - http://download.proxmox.com/debian/proxmox-ve-release-6.x.gpg | sudo apt-key add -

echo "deb http://download.proxmox.com/debian/pve buster pvetest" |  tee /etc/apt/sources.list.d/pve-install-repo.list
echo "deb http://download.proxmox.com/debian/ceph-nautilus buster main" |  tee /etc/apt/sources.list.d/ceph.list
sleep 1

apt update && apt dist-upgrade -y

echo "regarde!!!!!!!!!!!!!!!!!!!!!!!"
sleep 10
cat /etc/apt/sources.list.d/pve-enterprise.list
cat /etc/apt/sources.list.d/pve-enterprise.list
cat /etc/apt/sources.list.d/pve-enterprise.list
cat /etc/apt/sources.list.d/pve-enterprise.list
cat /etc/apt/sources.list.d/pve-enterprise.list
cat /etc/apt/sources.list.d/pve-enterprise.list
cat /etc/apt/sources.list.d/pve-enterprise.list
cat /etc/apt/sources.list.d/pve-enterprise.list
sleep 10

apt install proxmox-ve postfix open-iscsi -y

rm /etc/apt/sources.list.d/pve-enterprise.list

apt-get install xfce4 iceweasel lightdm xfce4-terminal gedit

reboot

#wget https://github.com/Automattic/simplenote-electron/releases/download/v1.10.0/Simplenote-linux-1.10.0-amd64.deb
#ls
#apt install gconf2 -y
#dpkg -i Simplenote-linux-1.10.0-amd64.deb 
#rm Simplenote-linux-1.10.0-amd64.deb

#echo "deb https://dl.bintray.com/resin-io/debian stable etcher" | tee /etc/apt/sources.list.d/etcher.list
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
#apt update
#apt install etcher-electron

#https://github.com/Automattic/simplenote-electron/releases/tag/v1.10.0

#a voir
#/etc/environment

#https://unix.stackexchange.com/questions/460478/debian-su-and-su-path-differences

#grub
#------------

