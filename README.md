# nva-manualscan

**__1. basicnmapcheck_v3.4.sh__**

This script automates the process of running Nmap scans on a list of IP addresses specified in a file called "targets.txt". The script accepts several command-line options, such as -p to specify the protocol (TCP or UDP), -s to specify the speed of the scan (ranging from sneaky to aggressive), and -v to specify the intensity of version guessing. It also creates a directory with the IP address name, and saves the output of the scan in this directory. The script also has options to include exclude options for nmap and options to enable and disabling -n.

**checkcategories.sh**

This script helps user to find the description of the nmap script or category of the script. 
This script takes one to three arguments. The first argument is the name of the script or the category of the script. 
- If the user provides one argument, the script will check if the script provided by the user is present in the nmap script directory if it is present, it will print the help of the script, otherwise it will search for the category provided by the user in the script directory and prints the scripts which belongs to the provided category.  - If the user provides two arguments, the script will search for the first category provided in the second category of the script directory and prints the script names which belongs to the provided categories. 
- If the user provides three arguments, the script will search for the first category in the second category and in the third category of the script directory and prints the script names which belongs to the provided categories. 
- If the user doesn't provide any argument or provides more than 3 arguments, it will print the categories of the nmap script and their descriptions.

**Nessus-checker**

This script is a multi-threaded command execution tool that is written in Python. It reads in two CSV files, "Commands.csv" and "Services.csv", and uses the data from these files to create a list of commands to be executed.

The "Commands.csv" file contains a list of commands that are to be executed, and the "Services.csv" file contains a list of target services, each with an IP address, port, and service name. The script uses this data to construct a list of commands to be executed, where each command is in the form of "service, command" as specified in the comments.

The script uses the threading library to create worker threads that process the command list in parallel, speeding up the overall execution time. Each thread calls the "process_data" function, which retrieves a command from the queue, prints the command, and execute it. The subprocess.Popen class is used to execute the command, and the results are written to a new file.

The script also includes error handling for missing input files and other potential errors, like if the input file is not readable, script will exit with error message.

In summary, this script is a tool that reads in a list of commands and a list of target services from CSV files, constructs a list of commands to be executed, and then executes those commands in parallel using worker threads for faster execution.

**update.sh**

This script is a bash script that is designed to update and clean up a Linux system. It first checks if the user running the script has root privilege by checking the EUID variable. If the user does not have root privilege, the script exits.

If the user has root privilege, the script proceeds to run the following commands:

apt-get update: This command updates the package lists for upgrades for packages that are installed on the system.

apt-get -y --with-new-pkgs upgrade: This command upgrades the packages that are installed on the system to their latest version. The -y flag tells the command to assume "yes" as an answer to all prompts, and the --with-new-pkgs flag tells the command to install new packages that are required to upgrade the current packages.

apt -y autoremove: This command removes packages that were automatically installed to satisfy dependencies for other packages and are no longer needed. The -y flag tells the command to assume "yes" as an answer to all prompts.

apt clean: This command removes all files from the package manager's cache, which is a directory that stores package files that are downloaded from the Internet.

apt purge -y $(dpkg -l| awk '/^rc/ {print $2}'): This command removes packages that are marked as "rc" (for "removal candidate") in the package manager's status database. The dpkg -l command lists all packages that are installed on the system, and the awk command filters the list to show only the packages that are marked as "rc". The apt purge -y command then removes these packages. The -y flag tells the command to assume "yes" as an answer to all prompts.

In summary, this script updates the system, upgrades the packages, removes unneeded packages, cleans the package manager's cache, and removes packages that are marked as "removal candidates" in the package manager's status database.
