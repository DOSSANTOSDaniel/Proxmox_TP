# Proxmox_TP
* Modification des sources
* Mise à jour
* Enlever la bannière de subscription
* Installation et configuration de fail2ban
* Installation de Molly-guard
* Installation de rkhunter
* Installation de Mlocate
* Installation de vim
* Installation de net-tools
* Installation de at
* Purge de l'ancien Kernel

# Attention
- pas besoin de configurer le PATH ainsi:
- echo "PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin" >> /home/$usertos/.bashrc
- source /home/daniel/.bashrc
- echo "PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin" >> /root/.bashrc 
- source /root/.bashrc
Sur Debian 10 quand on tape "su -" nous avons accès au répertoire /sbin quand on appel une application.
# Créer USB bootable de Debian 10
wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-10.1.0-amd64-netinst.iso

Brancher la clé USB

Détecter la clé
lsblk
Plus d'infos: fdisk -l

Démonter la clé
umount /dev/sdx

Copier
dd bs=1M if=debian-10.1.0-amd64-netinst.iso of=/dev/sdc status=progress oflag=sync
