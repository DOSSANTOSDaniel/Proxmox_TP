#!/bin/bash

apt update && apt dist-upgrade -y

apt install task-gnome-desktop -y

#tasksel install desktop gnome-desktop

tasksel install laptop

systemctl set-default graphical.target

wget https://github.com/Automattic/simplenote-electron/releases/download/v1.10.0/Simplenote-linux-1.10.0-amd64.deb
apt install gconf2 -y
dpkg -i Simplenote-linux-1.10.0-amd64.deb
sleep 1
rm Simplenote-linux-1.10.0-amd64.deb

echo "deb https://dl.bintray.com/resin-io/debian stable etcher" | tee /etc/apt/sources.list.d/etcher.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
apt update
apt install etcher-electron -y

apt install sudo -y
usermod -aG sudo 
