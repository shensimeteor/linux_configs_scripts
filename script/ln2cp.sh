#!/bin/bash
## make the soft link file as a real file (a copy not a link to the original file)

if [ $# -eq 0 ]; then
    echo "no files is supplied!"
    exit
fi

narg=$#
for ((i=1; i<=$narg; i=i+1)); do
    if [ ! -e $1 ]; then
        "can not find $1, skip it"
        continue
    fi
    if [ -d $1 ]; then
        echo "$1 is a directory, ignore it!"
        continue
    fi
    cp -L $1 $1.___bk
    rm $1
    mv $1.___bk $1
    shift
done
