#!/bin/bash

narg=$#
if [ $narg -eq 2 ]; then
    pattern=$1
    time_criterion=$2
    prompt=1
elif [ $narg -eq 3 ] && [ "$1" == "-f" ]; then
    pattern=$2
    time_criterion=$3
    prompt=0
else
    echo "<Usage>: "
    echo " 1. $0  <ps_aux_grep_pattern>  <time_criterion_seconds> (prompt before kill)"
    echo " 2. $0  -f  <ps_aux_grep_pattern> <time_criterion_seconds> (force kill!)"
    exit 2
fi

declare -a pid
declare -a timex
declare -a cmd
cnt=0

IFS=$'\n';
for line in $(ps aux | grep "$pattern" | tr -s " " | cut -d " " -f 2,10,11-); do
    pid[$cnt]=$(echo $line | cut -d ' ' -f 1);
    timex[$cnt]=$(echo $line | cut -d ' '  -f 2);
    cmd[$cnt]="$(echo $line | cut -d ' ' -f 3-)";
    cnt=$(($cnt+1))
done
#filter by time
declare -a filter_pid
declare -a filter_tim
declare -a filter_cmd
xcnt=0
for ((i=0;i<$cnt;i++)); do
    min=$(echo ${timex[$i]} | cut -d : -f 1 )
    sec=$(echo ${timex[$i]} | cut -d : -f 2 )
    seconds=$((10#$min*60+10#$sec))
    if [ ${seconds} -gt $time_criterion ]; then
        filter_pid[$xcnt]=${pid[$i]}
        filter_tim[$xcnt]=${timex[$i]}
        filter_cmd[$xcnt]=${cmd[$i]}
        xcnt=$(($xcnt+1))
    fi
done
#
if [ $xcnt -eq 0 ]; then
   echo "nothing to kill"
   exit 
fi
if [ $prompt -eq 1 ]; then
   echo "You will kill the following process"
   for ((i=0;i<$xcnt;i++)); do
       echo "- ${filter_pid[$i]}  ${filter_tim[$i]}  ${filter_cmd[$i]}"
   done
   read -e -p "Continue(Y/n?)" ans
   if [ $ans == "Y" ] || [ $ans == "y" ]; then
       kill "${filter_pid[@]}"
   fi
else
    kill "${filter_pid[@]}"
fi







