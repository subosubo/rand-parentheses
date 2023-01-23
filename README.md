# nva-manualscan

This script automates the process of running Nmap scans on a list of IP addresses specified in a file called "targets.txt". The script accepts several command-line options, such as -p to specify the protocol (TCP or UDP), -s to specify the speed of the scan (ranging from sneaky to aggressive), and -v to specify the intensity of version guessing. It also creates a directory with the IP address name, and saves the output of the scan in this directory. The script also has options to include exclude options for nmap and options to enable and disabling -n.
