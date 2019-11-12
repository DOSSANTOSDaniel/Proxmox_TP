#!/bin/bash

# Description:
#	Tente de résoudre les problèmes les plus frequents
#----------------------------------------------------------------#
# Usage: ./Si_Erreur.sh
#	Exécuter le script en root!
# 	Se connecter en root avec cette commande "su -" !
#	Durée: ~ minutes
#
# Auteur:
#  	Daniel DOS SANTOS < daniel.massy91@gmail.com >
#----------------------------------------------------------------#

# Linux peut rencontrer un problème avec certaines cartes graphiques AMD, on va donc modifier les paramètres de démarrage du noyau.
sed -i -e 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet spalsh"/GRUB_CMDLINE_LINUX_DEFAULT="nomodeset quiet spalsh"/' /etc/default/grub
sleep 1
update-grub

# C'est un gestionnaire d'énergie pour les pc portable, il peut entrée en comflict avec le système.
apt remove tlp --purge

# supprimer network-manager car si non pve-cluster peut ne pas démarrer!!!
apt remove network-manager --purge
