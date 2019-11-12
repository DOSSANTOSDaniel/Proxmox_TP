#!/bin/bash

# Linux peut rencontrer un problème avec certaines cartes graphiques AMD, on va donc modifier les paramètres de démarrage du noyau.
sed -i -e 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet spalsh"/GRUB_CMDLINE_LINUX_DEFAULT="nomodeset quiet spalsh"/' /etc/default/grub
sleep 1
update-grub

# C'est un gestionnaire d'énergie pour les pc portable, il peut entrée en comflict avec le système.
apt remove tlp --purge

