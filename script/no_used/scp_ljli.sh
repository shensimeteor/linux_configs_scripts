#!/bin/bash
if [ "$#" -ne "1" ]; then
    echo "Usage: ./scp_ljli.sh <filename>"
    exit
fi

scp $1 ljli@159.226.113.51:~/ss/
