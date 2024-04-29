#!/usr/bin/env bash

execute_remotessh(){
    # Usage: execute_remotessh servername command
    # Example: execute_remotessh server1 "ls -l"
    # Example: execute_remotessh $servername "echo '$SSHPASS'| sudo -S dmidecode -t 0 | grep -E '(Firmware Revision)'| sed 's/[[:space:]]*//'| sed -E 's/^[a-zA-Z :]+//'"
    
    # Old script.  Fix auth.
    export SSHPASS=$(cat ~/.pass);
    servername=$1;
    command="$2";
    results=$(sshpass -e ssh -T -o NumberOfPasswordPrompts=1 -o StrictHostKeyChecking=no -o ConnectTimeout=$SSHTIMEOUT $servername "$command";)
    if [ "$results" == '' ]; then results="NA"; fi
    echo "$results"
}