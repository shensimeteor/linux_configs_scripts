#!/bin/bash
declare -a arr
arr=($(ncdump -v platform $1 | cat -n | grep "platform =" | tr -s " "))
line=$((${arr[0]} + 1))
arr=($(ncdump -v platform $1 | cat -n | tail -n 1 | tr -s " " ))
last=$((${arr[0]}))
ncdump -v platform $1 | sed -n "$line,$last p" | cut -d "\"" -f 2 | cut -c 7-12 | sed '/^ *$/g' |  sort |uniq -c 

