#!/bin/bash
if [ -e "$1" ]; then
    scp $1 ljli@159.226.113.51:~/sstemp/
fi
