#!/bin/bash

# variables réseau
ipnet=$(hostname -I | awk '{print $1}')
ipwifi=$(hostname -I | awk '{print $2}')
usertos=$(w | awk '{print $1}' | awk 'NR==3')

apt update && apt full-upgrade -y

# supprimer network-manager car si non pve-cluster peut ne pas démarrer!!!
apt remove network-manager --purge

# Installation d'une interface graphique
apt install xorg -y
apt install lightdm -y

while [ : ]
do
echo -e "\n
+---------------+
|  Mate     [1] |
|  Cinnamon [2] |
|  LXQT     [3] |
|  XFCE4    [4] |
+---------------+  
"
read -p "Choix de l'interface graphique : " choix
echo " "

case $choix in
	1 )
		# Install Mate
    apt install task-mate-desktop -y
    apt install mate-desktop -y
    apt install mate-desktop-common -y
    apt install mate-desktop-environment task-french -y
    apt install mate-desktop-environment-extra -y
    apt install mate-desktop-environment-extras -y
    break
		;;
	2 )
		# Install Cinnamon
    apt install cinnamon-desktop-environment cinnamon-common -y
    apt install task-cinnamon-desktop task-french -y
    break
		;;
	3 )
		# Install LXQT
    apt install task-lxqt-desktop task-french lxqt -y
    break
		;;
  4 )
		# Install XFCE4
    apt install task-xfce-desktop xfce4 task-french -y
    break
		;;
	* )
		echo "Erreur de saisie !"
		;;
esac
done

# démarrage automatique de l'interface graphique au boot de la machine
systemctl set-default graphical.target

### installation et configuration des applications vues en cours (Open source)
apt install sudo -y
usermod -aG sudo $usertos

apt install vim -y

apt install ufw -y
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 80
ufw allow 443
ufw allow 8006
ufw enable -y
ufw status

apt install fail2ban -y
sleep 1
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

apt install molly-guard -y
apt install rkhunter -y
apt install mlocate -y
apt install vim -y
apt install glances -y
apt install net-tools -y

### Installation d'applications supplémentaires (pour mieux faire la transition de windows vers Linux)
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

# Installation de Sublime text
apt install apt-transport-https -y
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
apt-get update
apt-get install sublime-text -y

# Installation de Wireshark
apt install wireshark -y
usermod -a -G wireshark $usertos
chgrp wireshark /usr/bin/dumpcap
chmod 771 /usr/bin/dumpcap
setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap

# installation de google chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb -y
echo "
### THIS FILE IS AUTOMATICALLY CONFIGURED ###
# You may comment out this entry, but any other modifications may be lost.
deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main
" > /etc/apt/sources.list.d/google-chrome.list
apt update && apt upgrade -y

# Installation de LibreOffice
apt install libreoffice -y
apt-get install libreoffice-voikko
apt-get install openclipart-libreoffice
wget http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.7_all.deb
apt install ./ttf-mscorefonts-installer_3.7_all.deb -y
wget https://grammalecte.net/grammalecte/oxt/Grammalecte-fr-v1.5.0.oxt
rm ttf-mscorefonts-installer_3.7_all.deb

apt install vlc -y
apt install filezilla -y
apt install gdebi -y
apt install gedit -y
apt install iceweasel -y
apt install gparted -y
apt install screen -y
apt install diodon -y
apt install synaptic apt-xapian-index -y
apt install ncdu -y

### installation de dépendances ou autre
apt install software-properties-common -y
# installation de microapplications tierces
apt install firmware-linux firmware-linux-nonfree libdrm-amdgpu1 xserver-xorg-video-amdgpu -y

# Pilote ATI
apt install libgl1-mesa-dri xserver-xorg-video-ati -y

# install the headers and nvidia-drivers
apt install pve-headers -y
apt-get update 
apt-get install nvidia-driver -y

# Pilote Radeon
apt install libgl1-mesa-dri xserver-xorg-video-radeon -y

# optimisation pour laptop
tasksel install laptop

### Autres configurations
#  Enlever la bannière de subscription proxmox
cp /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js.save
sed -i "s/data.status !== 'Active'/false/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js

# mise à jour grub
# Le fichier /etc/default/grub contient l'option GRUB_DISABLE_OS_PROBER="true" donc windows no detecter par grub !!!
sed -i -e 's/GRUB_DISABLE_OS_PROBER="true"/GRUB_DISABLE_OS_PROBER="false"/' /etc/default/grub
update-grub

# nettoyage du système
apt autoremove --purge
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
