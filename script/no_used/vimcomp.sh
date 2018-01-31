#!/bin/bash
if [ -z "$DIRCMP" ]; then
    echo "set DIRCMP = the expt dir of compare plot"
    exit
fi
if [ ! -d "$DIRCMP" ]; then
    echo "can't find $DIRCMP"
    exit
fi

file=$1
vimdiff $(pwd)/$file $DIRCMP/$file
