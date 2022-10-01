#!/bin/bash

if [ $# -eq 1 ];
then
	if [ -f /usr/share/nmap/scripts/"$1" ]||[ -f /usr/share/nmap/scripts/"$1".nse ]||[ -f "$1" ]; then
		nmap --script-help "$1"	
	else	
		grep -ir "categories =" /usr/share/nmap/scripts | grep -i "$1"|grep -v filename|sort -u
	fi
elif [ $# -eq 2 ];
then
	grep -inr "categories =" /usr/share/nmap/scripts | grep -i "$1"| grep -i "$2" | grep -v filename|sort -u
elif [ $# -eq 3 ];
then 
	grep -inr "categories =" /usr/share/nmap/scripts | grep -i "$1"| grep -i "$2" | grep -i "$3" | grep -v filename| sort -u	
else
	echo -e "Command Failed - Invalid Parameter: Please enter nmap categories\n"
	
	echo -e  "Script Categories\n"

	echo -e "\tNSE scripts define a list of categories they belong to. Currently defined categories are\n 
	auth, broadcast, brute, default. discovery, dos, exploit, external, fuzzer, intrusive, malware,\n 
	safe, version, and vuln. Category names are not case sensitive. The following list describes each\n 
	category.\n"
	echo -e "\tauth - These scripts deal with authentication credentials (or bypassing them) on the target system.\r 
	Examples include x11-access, ftp-anon, and oracle-enum-users. Scripts which use brute force attacks\r 
	to determine credentials are placed in the brute category instead.\n"
	echo -e "\tbroadcast - Scripts in this category typically do discovery of hosts not listed on the command line\r
       	by broadcasting on the local network. Use the newtargets script argument to allow these scripts to\r
       	automatically add the hosts they discover to the Nmap scanning queue.\n"
	echo -e "\tbrute - These scripts use brute force attacks to guess authentication credentials of a remote server.\r
       	Nmap contains scripts for brute forcing dozens of protocols, including http-brute, oracle-brute, snmp-brute, etc."
	echo -e "\tdefault - These scripts are the default set and are run when using the -sC or -A options rather\r
       	than listing scripts with --script. This category can also be specified explicitly like any other\r
       	using --script=default. Many factors are considered in deciding whether a script should be run by default:\n"
	echo -e "\tdiscovery - These scripts try to actively discover more about the network by querying public\r
       	registries, SNMP-enabled devices, directory services, and the like. Examples include html-title (obtains\r
       	the title of the root path of web sites), smb-enum-shares (enumerates Windows shares), and\r
       	snmp-sysdescr (extracts system details via SNMP).\n"
	echo -e "\tdos - Scripts in this category may cause a denial of service. Sometimes this is done to test\r
       	vulnerability to a denial of service method, but more commonly it is an undesired by necessary side effect\r
       	of testing for a traditional vulnerability. These tests sometimes crash vulnerable services.\n"
	echo -e "\texploit - These scripts aim to actively exploit some vulnerability. Examples include jdwp-exec and http-shellshock.\n"
	echo -e "\texternal - Scripts in this category may send data to a third-party database or other network\r
       	resource. An example of this is whois-ip, which makes a connection to whois servers to learn about the\r
       	address of the target. There is always the possibility that operators of the third-party database will record\r
       	anything you send to them, which in many cases will include your IP address and the address of the target.\r
       	Most scripts involve traffic strictly between the scanning computer and the client; any that do not are placed in this category.\n"
	echo -e "\tfuzzer - This category contains scripts which are designed to send server software unexpected or\r
       	randomized fields in each packet. While this technique can useful for finding undiscovered bugs and vulnerabilities\r
       	in software, it is both a slow process and bandwidth intensive. An example of a script in this category is dns-fuzz,\r
       	which bombards a DNS server with slightly flawed domain requests until either the server crashes or a user specified time limit elapses.\n"
	echo -e "\tintrusive - These are scripts that cannot be classified in the safe category because the risks are too high\r
       	that they will crash the target system, use up significant resources on the target host (such as bandwidth or CPU time),\r
       	or otherwise be perceived as malicious by the target's system administrators. Examples are http-open-proxy (which attempts\r
       	to use the target server as an HTTP proxy) and snmp-brute (which tries to guess a device's SNMP community string by sending\r
       	common values such as public, private, and cisco). Unless a script is in the special version category, it should be\r
       	categorized as either safe or intrusive.\n"
	echo -e "\tmalware - These scripts test whether the target platform is infected by malware or backdoors.\r
       	Examples include smtp-strangeport, which watches for SMTP servers running on unusual port numbers, and auth-spoof,\r
       	which detects identd spoofing daemons which provide a fake answer before even receiving a query. Both of these behaviors\r
       	are commonly associated with malware infections.\n"
	echo -e "\tsafe - Scripts which weren't designed to crash services, use large amounts of network bandwidth or other\r
       	resources, or exploit security holes are categorized as safe. These are less likely to offend remote administrators,\r
       	though (as with all other Nmap features) we cannot guarantee that they won't ever cause adverse reactions. Most of\r
       	these perform general network discovery. Examples are ssh-hostkey (retrieves an SSH host key) and html-title (grabs the title from a web page). \r
	Scripts in the version category are not categorized by safety, but any other scripts which aren't in safe should be placed in intrusive.\n"
	echo -e "\tversion - The scripts in this special category are an extension to the version detection feature and\r
	cannot be selected explicitly. They are selected to run only if version detection (-sV) was requested.\r 
	Their output cannot be distinguished from version detection output and they do not produce service or host script results.\r
       	Examples are skypev2-version, pptp-version, and iax2-version.\n"
	echo -e "\tvuln - These scripts check for specific known vulnerabilities and generally only report results if \r
	they are found. Examples include realvnc-auth-bypass and afp-path-vuln.\n"
	exit 2

fi

