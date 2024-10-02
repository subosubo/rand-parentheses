#!/bin/bash

function usage {
    echo "Usage:"
    echo "=========="
    echo "Step 1: Add IP targets into targets.txt"	
    echo "Step 2: $0 [-p tcp/udp/all] [-s 1/2/3/4] [-v 1/2/3] [-h]"
    echo ""
    echo "	-a: Pingtest"
    echo "	-p: Protocol. Defaults to tcp"
    echo "	-s: Speed. (1:Sneaky, 2:Polite, 3:Normal - minrate=300, 4:Aggressive - minrate=500)"
    echo "	    Defaults to Aggressive - minrate=1000,host-timeout=15m "
    echo "	-v: Version Guessing. (1:Insensity=7, 2:Intensity=8, 3:Intensity=9)" 
    echo "	    Defaults at Intensity=7"
    echo "	-h: Help"
}

function pingtest {
	nmap -sn -n -oN ${OUTDIR}/pingtest.txt -iL ${OUTDIR}/targets.txt
}

#Default Options
performance=""
service_guess=""
proto="tcp"
OUTDIR="$(pwd)"

##To include exclude options for nmap
##To have options for enabling and disabling -n

if [[ -z $1 ]];
then 
    printf "No parameter detected."
    usage; exit 1;
fi

#Menu
while getopts "s:v:p:ah" opt; 
do
    case "$opt" in
        s) performance=${OPTARG} ;;
    	v) version_guess=${OPTARG} ;;
        p) proto=${OPTARG} ;;
	a) pingtest; exit 0;;
        h) usage; exit 0;;
        #*) usage; exit 0;;
    esac
done

shift "$((OPTIND-1))"

case "$performance" in
    1) speed="-T1" ;;
    2) speed="-T2" ;;
    3) speed="-T3 --min-rate=300" ;;
    4) speed="-T4 --min-rate=500" ;;
    *) speed="-T4 --min-rate=1000 --host-timeout=15m" ;;
esac

case "$version_guess" in
    2) versionint="-sV --version-intensity 8";;
    3) versionint="-sV --version-all";;
    *) versionint="-sV";;
esac

case "$proto" in
    tcp) protocol="tcp" ;;
    udp) protocol="udp" ;;
    all) protocol="all" ;;
    *)   protocol="tcp" ;;	
esac

#nmap_opt="--reason -vvv -n -Pn ${versionint} ${speed} --script=vuln"
nmap_opt="-vv -n -Pn ${versionint} ${speed} --script=discovery"

for ip in $(cat ${OUTDIR}/targets.txt)
do
    if [[ -z $ip ]]; then #if there's no input in file
        continue
    fi

    if [ ! -d ${OUTDIR}/${ip} ]; then	
        mkdir -p ${OUTDIR}/${ip}
    fi

    printf "Scanning Open Ports for "$ip"\n" 
	
    if [[ $protocol == "tcp" || $protocol == "all" ]]; then
        ports=$(nmap -n -Pn -p- $speed "$ip" | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)
		
        if [[ ! -z $ports ]]; then
            echo -e "TCP ports for nmap to scan: $ports"
            echo -e "nmap ${nmap_opt} -oA ${OUTDIR}/${ip}/${ip} -p ${ports} ${ip}"
            sleep 1
            nmap ${nmap_opt} -oA ${OUTDIR}/${ip}/${ip} -p ${ports} ${ip}
        else
            printf "[!] No TCP ports found for "$ip"\n"
        fi
    fi

    if [[ $protocol == "udp" || $protocol == "all" ]]; then
        ports=$(nmap -sU -n -Pn -p- $speed "$ip" | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)
		
        if [[ ! -z $ports ]]; then
            echo -e "UDP ports for nmap to scan: $ports"
            echo -e "nmap -sU ${nmap_opt} -oA ${OUTDIR}/${ip}/${ip} -p ${ports} ${ip}"
            sleep 1
            nmap -sU ${nmap_opt} -oA ${OUTDIR}/${ip}/${ip}U -p ${ports} ${ip}
        else
            printf "[!] No UDP ports found for "$ip"\n"
        fi
    fi
done 
