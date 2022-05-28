#!/usr/bin/python
import subprocess
import os
import queue
import threading
import time
import sys
from queue import Queue
from subprocess import (Popen, PIPE)

class myThread (threading.Thread):
   def __init__(self, threadID, q):
      threading.Thread.__init__(self)
      self.threadID = threadID
      self.q = q
   def run(self):
      process_data(self.threadID, self.q)

def process_data(threadName,q):
    #This is a worker thread; Parameters are the ThreadId/Name and the workqueue.
    #Get commands from WorkQueue and exits when encounters None
    #Breaks the command into callable subprocess parameters for command execution
    #Finishes execution and marks the task in queue as done

    while True:
        data = q.get()
        if data is None:
            break
        timestr = time.strftime("%Y%m%d-%H%M%S")
        print("\rThread %s CREATED [%s]: %s" % (threadName, timestr, data))
        command,output = [x.strip() for x in data.split('>')]
        
        #creates new file for writing
        outfile = open(output,'w')
        
        #subprocess.Popen(shell=false -disables all shell based features, so no code injection vulnerability) 
        #execute = subprocess.Popen(command.split(), stdout=outfile, stderr=subprocess.STDOUT,  universal_newlines=None)
        nonewline = subprocess.Popen(('echo', '-n'), stdout=subprocess.PIPE)
        execute = subprocess.Popen(command.split(), stdin=nonewline.stdout, stdout=outfile, stderr=subprocess.STDOUT,  universal_newlines=None)
        execute.communicate()
        outfile.close()

        print("\rThread %s COMPLETED" % (threadName))
        print("\rThread %s: %s commands left in Queue" % (threadName, q.qsize()))
        q.task_done()

def construct():
    #Constructs the Input commandList
    
    # Getting current directory.
    dir = os.getcwd()
    dirVA = dir + "/VA/"

    if not os.path.exists(dirVA):
        os.makedirs(dirVA)

    # Required files, "Services.csv" and "Commands.txt"
    commandsInputFile = dir + "/Commands.csv"
    servicesInputFile = dir + "/Services.csv"

    if not os.path.exists(commandsInputFile):
        print(commandsInputFile + " does not exists")
        print("The input format is Service,Command example: HTTPS,sslscan 192.168.1.1\n")
        exit(1)

    if not os.path.exists(servicesInputFile):
        print(servicesInputFile + " does not exists")
        print("The input format is IP,Port,Service, example: 192.168.1.1,22,ssh\n")
        exit(1)

    commands_file = open(commandsInputFile, "r")
    services_file = open(servicesInputFile, "r")

    # Read for list of commands from "Commands.csv"
    # List are populated by ignoring commands starting with "#" and stripped of trailing whitespaces
    if commands_file.readable():
        commandList = [line.rstrip() for line in commands_file if line[:1] != "#"]
        commands_file.close()

    # Read for list of targeted services from "Services.csv"
    if services_file.readable():
        serviceList = [line.rstrip() for line in services_file if line[:1] != "#"]
        services_file.close()

    # Prepare a list of executions that are to be executed.
    executeList = []
    for x in range(0,len(serviceList)):
        ip,port,service = serviceList[x].split(',')
        #print(ip + ":" + port + ":" + service + ":")
        
        for y in range(0,len(commandList)):
            checkService,noncmd = commandList[y].split(',')
            if (service == checkService):   #verify that the targeted service and command type is the same
                noncmd = noncmd.replace("$ip", ip)
                noncmd = noncmd.replace("$port", port)
                noncmd = noncmd.replace("$service", service)
                noncmd = noncmd.replace("$dir", dirVA)
                #print("non: "+noncmd)
                executeList.append(noncmd)

    # Remove duplicate commands from executeList
    executeList = list(set(executeList))

    # Write 
    timestr = time.strftime("%Y%m%d-%H%M%S")
    filename = "executeList-" + timestr + ".txt" 
    file = open(filename,"w")

    for w in range(0,len(executeList)):
        file.write(str(w) + "," + executeList[w] + "\n")
    file.close()

    print("Number of prepared commands:" + str(len(executeList)) + "\n")

    for p in range(0,len(executeList)):
        print(str(p) + "," + executeList[p])
        
    return executeList
    
def main():
    DefaultThreadCount = 4 #Hardcoded_ThreatCount
    workQueue = Queue(maxsize=0) #maxsize=0 means no limit
    threads = []
    nameList = construct()
    starttime = time.strftime("%Y%m%d-%H%M%S")

    for threadID in range(DefaultThreadCount):
        thread = myThread(threadID,workQueue)
        thread.start()
        threads.append(thread)

    # Fill the queue
    try:
        for cmd in nameList:
            workQueue.put(cmd)

        workQueue.join()

        # Notify threads it's time to exit. For loop for each WorkerThread to received 'None'
        # exitFlag = 1
        for i in range(DefaultThreadCount):
            workQueue.put(None)

        # Wait for all threads to complete
        for t in threads:
            t.join()

        endtime = time.strftime("%Y%m%d-%H%M%S")
        print("\nScan Start Time: " + starttime + "\n" + "Scan End Time: " + endtime)
        
        #Dirty way to reset terminal. 
        #"https://unix.stackexchange.com/questions/435640/bash-print-gets-messed-up-after-running-script"
        subprocess.call(["stty","sane"])

    except KeyBoardInterrupt:
        sys.exit(1)

    #print ("Exiting Main Thread")

if __name__ == '__main__':
    main()
