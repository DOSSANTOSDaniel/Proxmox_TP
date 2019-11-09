#!/bin/bash

#TP Proxmox on Debian
#----------------------------
#https://computingforgeeks.com/how-to-install-proxmox-ve-on-debian/
#https://pve.proxmox.com/wiki/Package_Repositories#_proxmox_ve_test_repository    

apt update && apt dist-upgrade -y

usertos=$(w | awk '{print $1}' | awk 'NR==3')

# pas besoin car il faut sur debian faire "su -" obligatoire si non pas d'accès sbin
#echo "PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin" >> /home/$usertos/.bashrc
#sleep 1
#source /home/daniel/.bashrc
#echo "PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin" >> /root/.bashrc
#sleep 1 
#source /root/.bashrc

hostnamectl set-hostname pve1.proxmox.lan --static
 
ipnet=$(hostname -I | awk 'NR==1' | sed s'/.$//')
ipwifi=$(hostname -I | awk 'NR==2' | sed s'/.$//')
routetos=$(ip route | grep '^default via' | awk '{print $3}')
interfacewifi=$(ip link | grep ^3 | awk '{print $2}' | awk 'NR==1' | sed s'/://')
interfacenet=$(ip link | grep ^2 | awk '{print $2}' | awk 'NR==1' | sed s'/://')
read -p "Quelle type de connexion ? Wifi[w] ou Câble[c] : " typecon
if [ $typecon == "c" ]
then
    sed -i -e "s/iface $interfacenet inet dhcp/iface $interfacenet inet static/" /etc/network/interfaces
    echo "    address $ipnet/24" >> /etc/network/interfaces
    echo "    gateway $routetos" >> /etc/network/interfaces
elif [ $typecon == "w" ]
then
    echo "script pas compatible en wifi"
    exit 0
    #sed -i -e "s/iface $interfacewifi inet dhcp/iface $interfacewifi inet static/" /etc/network/interfaces
    #echo "    address $ipwifi/24" >> /etc/network/interfaces
    #echo "    gateway $routetos" >> /etc/network/interfaces
else
    echo " Erreur syntax redémarrer le script"
    exit 1
fi

echo $ipnet"pve1.proxmox.lan pve1" |  tee -a /etc/hosts

apt install gnupg -y

wget -qO - http://download.proxmox.com/debian/proxmox-ve-release-6.x.gpg | apt-key add -

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
sleep 5
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

