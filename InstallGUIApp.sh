#!/bin/bash

# Description:
#	Permet l'installation d'une station de travail avec un environnement graphique sur Proxmox
#----------------------------------------------------------------#
# Usage: ./InstallGUIApp.sh
#	Exécuter le script en root!
# 	Se connecter en root avec cette commande "su -" !
#	Durée: ~15 minutes
#
# Campatibilité:
#	Il est préférable de ne pas être connecté en Wifi.
#
# Auteurs:
#  	Daniel DOS SANTOS < daniel.massy91@gmail.com >
#----------------------------------------------------------------#

# variables réseau
ipnet=$(hostname -I | awk '{print $1}')
ipwifi=$(hostname -I | awk '{print $2}')
usertos=$(w | awk '{print $1}' | awk 'NR==3')
interfacewifi=$(ip link | grep ^3 | awk '{print $2}' | sed s'/://')
interfacenet=$(ip link | grep ^2 | awk '{print $2}' | sed s'/://')

apt update && apt full-upgrade -y

# Installation d'une interface graphique
tasksel

# démarrage automatique de l'interface graphique au boot de la machine
systemctl set-default graphical.target

### installation et configuration des applications vues en cours (Open source)
apt install sudo -y
usermod -aG sudo $usertos

apt install vim -y

apt install ufw -y
ufw status
ufw enable
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

apt install molly-guard -y
apt install rkhunter -y
apt install mlocate -y
apt install vim -y
apt install glances -y
apt install net-tools -y
apt install ncdu -y
apt install ntp -y
apt install screen -y

### installation de dépendances ou autre
apt install software-properties-common -y

### Autres configurations
#  Enlever la bannière de subscription proxmox
cp /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js.save
sed -i "s/data.status !== 'Active'/false/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js

# mise à jour grub
# Le fichier /etc/default/grub contient l'option GRUB_DISABLE_OS_PROBER="true" donc windows no detecter par grub !!!
sed -i -e 's/GRUB_DISABLE_OS_PROBER=true/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub
sleep 1
update-grub

# nettoyage du système
apt autoremove --purge -y
apt autoclean

# Purge des anciens Kernels
nbkern=$(dpkg --list | grep linux-image | wc -l)
if [[ -z "$nbkern" ]]
then
  echo -e "\n Pas de kernels a supprimer ! \n"
else
  for (( i=1; i<=$nbkern; i++ ))
  do
    onekern=$(dpkg --list | grep linux-image | awk '{print $2}' | awk "NR==$i")
    apt remove $onekern --purge -y
  done
fi

systemctl reboot
