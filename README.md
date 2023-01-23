# nva-manualscan

**basicnmapcheck_v3.4.sh
**

This script automates the process of running Nmap scans on a list of IP addresses specified in a file called "targets.txt". The script accepts several command-line options, such as -p to specify the protocol (TCP or UDP), -s to specify the speed of the scan (ranging from sneaky to aggressive), and -v to specify the intensity of version guessing. It also creates a directory with the IP address name, and saves the output of the scan in this directory. The script also has options to include exclude options for nmap and options to enable and disabling -n.

**checkcategories.sh
**

This script helps user to find the description of the nmap script or category of the script. 
This script takes one to three arguments. The first argument is the name of the script or the category of the script. 
- If the user provides one argument, the script will check if the script provided by the user is present in the nmap script directory if it is present, it will print the help of the script, otherwise it will search for the category provided by the user in the script directory and prints the scripts which belongs to the provided category.  - If the user provides two arguments, the script will search for the first category provided in the second category of the script directory and prints the script names which belongs to the provided categories. 
- If the user provides three arguments, the script will search for the first category in the second category and in the third category of the script directory and prints the script names which belongs to the provided categories. 
- If the user doesn't provide any argument or provides more than 3 arguments, it will print the categories of the nmap script and their descriptions.
