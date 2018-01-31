#!/bin/bash
narg=$#
for ((i=1;i<=$narg;i=i+1)); do
    file=$1
    lnfile=$(printf "%02d" $i)
    ln -sf $file ob$lnfile".ascii"
    shift
done
    
