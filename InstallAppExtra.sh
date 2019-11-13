#!/bin/bash

# Description:
#	Permet l'application supplémentaire de programmes (pour mieux faire la transition de windows vers Linux)
#----------------------------------------------------------------#
# Usage: ./InstallGUIAppExtra.sh
#	Exécuter le script en root!
# 	Se connecter en root avec cette commande "su -" !
#	Durée: ~ minutes
#
# Auteurs:
#  	Daniel DOS SANTOS < daniel.massy91@gmail.com >
#----------------------------------------------------------------#

### Installation

usertos=$(w | awk '{print $1}' | awk 'NR==3')
interfacewifi=$(ip link | grep ^3 | awk '{print $2}' | sed s'/://')
interfacenet=$(ip link | grep ^2 | awk '{print $2}' | sed s'/://')

# installation de simplenote
wget https://github.com/Automattic/simplenote-electron/releases/download/v1.10.0/Simplenote-linux-1.10.0-amd64.deb
apt install gconf2 -y
dpkg -i Simplenote-linux-1.10.0-amd64.deb
sleep 1
rm Simplenote-linux-1.10.0-amd64.deb

# installation de etcher
apt install zenity -y
echo "deb https://deb.etcher.io stable etcher" | tee /etc/apt/sources.list.d/balena-etcher.list
sleep 1
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
apt update
apt install balena-etcher-electron -y

# Installation d'AnyDesk
wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | apt-key add -
echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk-stable.list
sleep 1
apt update
apt install anydesk -y

# Installation de Wireshark
apt install wireshark -y
usermod -a -G wireshark "$usertos"
chgrp wireshark /usr/bin/dumpcap
chmod 771 /usr/bin/dumpcap
setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap
ip link set "$interfacenet" promisc on
ip link set "$interfacewifi" promisc on

# Installation de Visual Studio Code
wget http://packages.microsoft.com/repos/vscode/pool/main/c/code/code_1.40.1-1573664190_amd64.deb
apt install ./code_1.40.1-1573664190_amd64.deb -y
sleep 1
rm code_1.40.1-1573664190_amd64.deb

# installation de google chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb -y
echo "
### THIS FILE IS AUTOMATICALLY CONFIGURED ###
# You may comment out this entry, but any other modifications may be lost.
deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main
" > /etc/apt/sources.list.d/google-chrome.list
apt update && apt upgrade -y
rm google-chrome-stable_current_amd64.deb

# Installation de LibreOffice
apt install libreoffice -y
apt install libreoffice-voikko -y
apt install openclipart-libreoffice -y
wget http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.7_all.deb
apt install ./ttf-mscorefonts-installer_3.7_all.deb -y
wget https://grammalecte.net/grammalecte/oxt/Grammalecte-fr-v1.5.0.oxt
rm ttf-mscorefonts-installer_3.7_all.deb

# Autres programmes
apt install vlc -y
apt install filezilla -y
apt install gdebi -y
apt install gedit -y
apt install gparted -y
apt install diodon -y
apt install nextcloud-desktop -y
apt install zenmap -y
apt install keepassx -y
apt install rhythmbox -y
apt install putty -y
apt install git -y

# nettoyage du système
apt autoremove --purge -y
apt autoclean

systemctl reboot
