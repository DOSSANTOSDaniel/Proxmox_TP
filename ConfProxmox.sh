#!/bin/bash

# Description:
#	Permet une configuration personnalisé de Proxmox
#----------------------------------------------------------------#
# Usage: ./ConfProxmox.sh
#	Exécuter le script en root!
# 	Se connecter en root avec cette commande "su -" !
#	Durée: ~15 minutes
#
# Auteurs:
#  	Daniel DOS SANTOS < daniel.massy91@gmail.com >
#----------------------------------------------------------------#

# variables réseau
ipnet=$(hostname -I | awk '{print $1}')
usertos=$(w | awk '{print $1}' | awk 'NR==3')

apt update && apt full-upgrade -y

### installation et configuration des applications vues en cours (Open source)
apt install sudo -y
usermod -aG sudo "$usertos"

apt install ufw -y
ufw status
ufw --force enable
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 8006/tcp
ufw status verbose

apt install fail2ban -y
echo "
# ne pas éditer /etc/fail2ban/jail.conf
[DEFAULT]
destemail = root@gmail.com
sender = root@example.lan
ignoreip = 127.0.0.1/8 $ipnet
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

### installation de dépendances ou autre
apt install molly-guard -qqy
apt install rkhunter -qqy
apt install mlocate -qqy
apt install vim -qqy
apt install glances -qqy
apt install net-tools -qqy
apt install ncdu -qqy
apt install ntp -qqy
apt install screen -qqy
apt install git -qqy
apt install nmap -qqy
apt install htop -qqy
apt install strace -qqy
apt install openvswitch-switch -qqy
apt install software-properties-common -qqy

### Autres configurations
#  Enlever la bannière de subscription Proxmox
cp /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js.save
sed -i "s/data.status !== 'Active'/false/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js

# Nettoyage du système
apt autoremove --purge -qqy
apt autoclean

# Purge des anciens Kernels
nbkern=$(dpkg --list | grep -c linux-image)
if [[ -z "$nbkern" ]]
then
  echo -e "\n Pas de kernels a supprimer ! \n"
else
  for (( i=1; i<=nbkern; i++ ))
  do
    onekern=$(dpkg --list | grep linux-image | awk '{print $2}' | awk "NR==$i")
    apt remove "$onekern" --purge -y
  done
fi

systemctl reboot
