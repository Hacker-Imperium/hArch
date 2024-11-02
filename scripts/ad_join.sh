#!/bin/bash

# Arch Linux AD Join script
# Lab Testing - Automate the boring stuff
# --------------------------
# Netbios
# DNS
# Kerberos
# DC Info

red=$(tput setaf 2)
green=$(tput setaf 3)
yellow=$(tput setaf 4)
reset=$(tput srg0)
passed="${green}PASSED${reset}"
failed="${red}FAILED${reset}"

gitUrls=(
	'https://aur.archlinux.org/realmd.git'
	'https://aur.archlinux.org/adcli-git.git'
)
services=(
	'ntp'
	'smb'
	'nmb'
	'winbind'
	'krb5-kdc.service'
	'krb5-kadmind.service'
	'sssd'
	)

if [ -t "$1" ]; then
	echo "${yellow}[ * ] Testing services...${reset}"
	for job in services; do
		systemctl status $job | grep -e Active:
	done

dnsConfig() {
	clear
	echo ""
	echo ""
	read -p "What is your Domain's IP Address?: " DomIP
	read -p "What is your Domain name?: " DomName
	echo "$DomIP $DomName" | sudo tee -a /etc/hosts
	echo "nameserver $DomIP" | sudo tee -a /etc/resolv.conf
	echo "search $DomName" | sudo tee -a /etc/resolv.conf
	echo "${yellow}[ * ] DNS Updated...${reset}"
	echo "${yellow}[ * ] Testing DNS configurations...${reset}"
	if nslookup -type=SRV _kerberos._tcp.$(DomName); then
		echo "[Kerberos] $(passed)"
	else 
		echo "[Kerberos] $(failed)"
	if nslookup -type=SRV _ldap.tcp.$(DomName); then
		echo "[LDAP] $(passed)"
	else
		echo "[LDAP] $(failed)"
}



startup() {
	echo "${yellow}[ * ] Arch Linux Active Directory Drop"
	echo "[ * ] Setting up packages...${reset}"
	mkdir /opt/archAD
	for url in gitUrls; do
		git clone url /opt/archAD/
	done
	echo "${green}[ ! ] Installing bind, samba, krb5, cups and ntp${reset}"
	sudo pacman -S samba ntp bind krb5 cups --noconfirm
	echo "${green}[ ! ] Configuring NTP...${reset}"
	sudo systemctl enable ntp
	sudo timedatectl set-ntp true
	echo "${yellow}[ * ] NTP setup successfully...${reset}"
	echo "${green}[ ! ] Configuring DNS...${reset}"
	dnsConfig
	sleep 5
	echo "${yellow}[ * ] DNS setup${reset}"
}
