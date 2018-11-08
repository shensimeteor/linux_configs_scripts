#!/bin/bash

if [ $# -ne 3 ] && [ $# -ne 2 ]; then
    echo "<usage> chmod_alldir.sh <root dir> <mod> [-f]"
    echo "will change <root dir> and all its descendant directories to <mod>"
    echo "with -f: force, otherwise, will print all dirs first for your confirm"
    exit
fi
if [ $# -eq 3 ] && [ $3 != "-f" ]; then
    echo "<usage> chmod_alldir.sh <root dir> <mod> [-f]"
    echo "will change <root dir> and all its descendant directories to <mod>"
    echo "with -f: force, otherwise, will print all dirs first for your confirm"
    exit
fi

dirs=$(find $1 -type d)
confirm=0
if [ $# -eq 2 ]; then
    for dir in $dirs; do
        echo chmod $2 $dir
    done
    read -p "confirm to chmod for ALL these dirs [y/N]?"  x
    if [ -n "$x" ] && ([ $x == "y" ] || [ $x == "Y" ]); then
        confirm=1
    fi
else
    confirm=1
fi

if [ $confirm -eq 1 ]; then
    for dir in $dirs; do
        chmod $2 $dir
    done
fi
