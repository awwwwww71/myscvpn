#!/bin/bash
# My Telegram : https://t.me/MasWayVPN
# ==========================================
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
# ==========================================
# Getting
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

BURIQ () {
    curl -sS https://mymasway.github.io/izin > /root/tmp
    data=( `cat /root/tmp | grep -E "^### " | awk '{print $2}'` )
    for user in "${data[@]}"
    do
    exp=( `grep -E "^### $user" "/root/tmp" | awk '{print $3}'` )
    d1=(`date -d "$exp" +%s`)
    d2=(`date -d "$biji" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))
    if [[ "$exp2" -le "0" ]]; then
    echo $user > /etc/.$user.ini
    else
    rm -f  /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f  /root/tmp
}
# https://mymasway.github.io/izin 
MYIP=$(curl -sS ipv4.icanhazip.com)
Name=$(curl -sS https://mymasway.github.io/izin | grep $MYIP | awk '{print $2}')
echo $Name > /usr/local/etc/.$Name.ini
CekOne=$(cat /usr/local/etc/.$Name.ini)

Bloman () {
if [ -f "/etc/.$Name.ini" ]; then
CekTwo=$(cat /etc/.$Name.ini)
    if [ "$CekOne" = "$CekTwo" ]; then
        res="Expired"
    fi
else
res="Permission Accepted..."
fi
}

PERMISSION () {
    MYIP=$(curl -sS ipv4.icanhazip.com)
    IZIN=$(curl -sS https://mymasway.github.io/izin | awk '{print $4}' | grep $MYIP)
    if [ "$MYIP" = "$IZIN" ]; then
    Bloman
    else
    res="Permission Denied!"
    fi
    BURIQ
}
PERMISSION
clear
if [[ "$IP" = "" ]]; then
PUBLIC_IP=$(wget -qO- ipinfo.io/ip);
else
PUBLIC_IP=$IP
fi
source /var/lib/maswayvpn/ipvps.conf
if [[ "$IP2" = "" ]]; then
domain=$(cat /etc/xray/domain)
else
domain=$IP2
fi
until [[ $VPN_USER =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "Username : " -e VPN_USER
		CLIENT_EXISTS=$(grep -w $VPN_USER /var/lib/maswayvpn/data-user-pptp | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo -e "Username ${RED}${VPN_USER}${NC} Already On VPS Please Choose Another"
			exit 1
		fi
	done
read -p "Password : " VPN_PASSWORD
read -p "Expired (Days) : " masaaktif
hariini=`date -d "0 days" +"%Y-%m-%d"`
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
clear

# Add or update VPN user
cat >> /etc/ppp/chap-secrets <<EOF
"$VPN_USER" pptpd "$VPN_PASSWORD" *
EOF

# Update file attributes
chmod 600 /etc/ppp/chap-secrets*
echo -e "### $VPN_USER $exp">>"/var/lib/maswayvpn/data-user-pptp"
cat <<EOF

============================
PPTP VPN
============================
IP/Host   : $PUBLIC_IP
Domain    : $domain
Username  : $VPN_USER
Password  : $VPN_PASSWORD
Created   : $hariini
Expired   : $exp
============================
Script By MASWAY VPN
EOF