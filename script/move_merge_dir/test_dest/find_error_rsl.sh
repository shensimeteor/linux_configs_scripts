#!/bin/bash

nf=$#
files=($*)
string="SUCCESS COMPLETE WRF"
for ((i=0;i<$nf;i++));do
    res=$(grep "$string" ${files[$i]})
    if [ -z "$res" ]; then
        echo ${files[$i]} 
    fi
done


    
