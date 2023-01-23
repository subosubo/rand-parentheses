# nva-manualscan

**basicnmapcheck_v3.4.sh**

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
