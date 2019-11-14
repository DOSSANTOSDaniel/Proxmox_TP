# Proxmox_TP

## Mise en place d'une station de travail Debian avec un environnement graphique et contenant le serveur Proxmox 

### Pour nous aider à réaliser l’installation de Proxmox 6.0 sur Debian 10 nous avons 2 scripts:

[InstallProxmoxDebian.sh](https://github.com/DOSSANTOSDaniel/Proxmox_TP/blob/master/InstallProxmoxDebian.sh) : Pour l’installation de Proxmox.

[InstallGUIApp.sh](https://github.com/DOSSANTOSDaniel/Proxmox_TP/blob/master/InstallGUIApp.sh) : Pour l’installation de l’interface graphique.

### Autres scripts : 

[InstallGUIAppExtra.sh](https://github.com/DOSSANTOSDaniel/Proxmox_TP/blob/master/InstallGUIAppExtra.sh) : Pour l’installation d’applications supplementaires.

[Si_Erreur.sh](https://github.com/DOSSANTOSDaniel/Proxmox_TP/blob/master/Si_Erreur.sh) : Si jamais l’interface graphique ne se lance pas chez vous.

  

## Etape par étape

### Faire de l’espace sur votre disque dur pour accueillir les nouvelles partitions Debian 

#### Sur Windows

Ouvrir un terminal et  tapez : diskmgmt.msc

L’application de gestion du stockage s'ouvre, il faut maintenant réduire la taille de votre disque pour laisser de l’espace pour Debian.

#### Dans un livecd avec Gparted

Créer une clé USB amorçable avec Balenaetcher contenant  la distribution GParted Live:

[https://gparted.org/livecd.php](https://gparted.org/livecd.php)

Démarrer votre système sur la clé et ouvrir Gparted pour modifier les partitions.

  

### Création d'une clé USB amorçable avec Debian 10 (Buster)

#### Sur Windows

Utiliser l’application Balenaetcher : [https://www.balena.io/etcher/](https://www.balena.io/etcher/)

#### Sur Ubuntu/Debian

Ouvrir un terminal.

Téléchargement de l’image système de Debian Buster:

wget [https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-10.1.0-amd64-netinst.iso](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-10.1.0-amd64-netinst.iso)

Brancher une clé USB sur votre ordinateur et lancer la commande lsblk pour identifier la clé USB, attention cette clé sera complètement formatée.

Démonter la clé USB avec la commande : umount /dev/sdx

Commencer la copie sur la clé USB avec la commande dd:

dd bs=1M if=debian-10*.iso of=/dev/sdX status=progress oflag=sync

#### Exemple d’installation de Debian sur un ordinateur:

1. French 
2. France 
3. Français 
4. Nom de la machine: Debian 
5. Domaine: vide 
6. Définir un mot de passe pour le compte root (x2) 
7. Définir un nom d’utilisateur 
8. Définir un mot de passe pour l’utilisateur (x2) 

#### Le partitionnement des disques

1. Méthode de partitionnement: manuel 
2. Choisir l’espace vide et créer deux partitions: 
    1. Partition 1: swap de 4 Go 
    2. Partition 2: ext4        / 

1. Faut-il appliquer les changements sur les disques ?  &lt;oui&gt; 
2. Faut-il utiliser un miroir dans le réseau ?  &lt;non&gt; 

#### Configuration des logiciels à installer

1. Configuration du pays miroir: France. 
2. Sélectionner ensuite  ftp.fr.debian.org. 
3. Valider le mandataire en laissant vide le formulaire et tapant directement Entrée. 
4. participation aux études des paquets: oui. 
5. Dans la sélection des logiciels, sélectionner: 
    1. serveur SSH. 
    2. utilitaires usuels système. 

#### Fin de l’Installation et configuration de grub

1. Installer le programme de démarrage GRUB sur le secteur d’amorçage ?  &lt;oui&gt; 
2. Pour installer le programme de démarrage GRUB sur les disques durs : répondre  oui. 
3. Sélectionner la ligne  ”/dev/sdX” correspondant à votre disque.  
4. Valider la fin de l’installation avec la touche Entrée. 
5.  Retirer la clé USB quand le pc  se sera éteint . 

#### Pour le lancement des scripts

apt install git

git clone https://github.com/DOSSANTOSDaniel/Proxmox_TP.git

cd Proxmox_TP

1. ./InstallProxmoxDebian.sh (installation de Proxmox) 
2. ./InstallGUIApp.sh (installation de l’interface graphique) 
3. ./InstallGUIAppExtra.sh (autres applications) 

Lancer d'abord le script 1 puis à la fin du script le système redémarrera, par la suite lancer le script 2 le système redémarrera aussi à la fin, et pour finir si vous voulez lancer le script 3.

  

#### Installation et configuration de Proxmox sur Debian:

Script: InstallProxmoxDebian.sh

Programmes installés et configurations:

Proxmox
Postfix
open-iscsi
Configuration DNS
Proxmox ve
Postfix
open-iscsi
Configuration DNS
Configuration Interface réseau

Si une fois l’ordinateur redémarré il n’a plus internet:

Tester la connexion avec la commande : ping 8.8.8.8

Demander une adresse IP au serveur DHCP avec la commande : dhclient

#### Installation d'un environnement graphique sur le poste Debian et installation de certaines applications:

Script: InstallGUIApp.sh

Pour l’environnement graphique vous avez le choix entre plusieurs interfaces:

1. environnement de bureau Debian 
2. gnome-desktop    GNOME 
3. xfce-desktop    Xfce 
4. kde-desktop    KDE Plasma 
5. cinnamon-desktop    Cinnamon 
6. mate-desktop    MATE 
7. lxde-desktop    LXDE 
8. lxqt-desktop    LXQt 

A vous de choisir. (perso j’ai choisi MATE, c’est un savant mélange entre stabilité et légèreté) 

Programmes installés et configurations:

Installation et configuration de l’interface graphique à l’aide de tasksel
Sudo
Vim
UFW
Création de règles de firewall UFW
Installation et configuration de Fail2ban
molly-guard
rkhunter
mlocate
vim
glances
net-tools
ncdu
ntp
screen
software-properties-common
Enleve la bannière de souscription proxmox
Configuration grub
Nettoyage du système

### Installations et configurations optionnelles

Script : InstallGUIAppExtra.sh 

Programmes installés et configurations

simplenote
etcher
AnyDesk
wireshark
google chrome
libreoffice
vlc
filezilla
gdebi
gedit
gparted
diodon
nextcloud-desktop
zenmap
keepassx
rhythmbox
putty
nettoyage du système
Visual Studio Code

* Attention
- pas besoin de configurer le PATH ainsi:
- echo "PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin" >> /home/$usertos/.bashrc
- source /home/daniel/.bashrc
- echo "PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin" >> /root/.bashrc 
- source /root/.bashrc
Sur Debian 10 quand on tape "su -" nous avons accès au répertoire /sbin quand on appel une application.
