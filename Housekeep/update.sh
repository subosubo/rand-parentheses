#!/bin/bash

#if not root, run as root
if (($EUID != 0 )); then
	#sudo /home/kali/Documents/scripts/housekeep/update.sh
	exit
fi
apt-get update
apt-get -y --with-new-pkgs upgrade
apt -y autoremove
apt clean
apt purge -y $(dpkg -l| awk '/^rc/ {print $2}')
#update all git child projects in /opt
sudo find /opt -mindepth 1 -maxdepth 1 -type d -exec sh -c 'echo "Pulling changes in {}"; cd "{}"; git pull' \;

