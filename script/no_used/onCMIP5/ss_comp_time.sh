#!/bin/bash
if [ $# -ne 2 ]; then
    echo "usage: $0 <thu_time_list> <esg_time_list>"
    exit
fi

thu_list=$1
esg_list=$2

i=0
for line in $(cat $thu_list | sed 's/[[:blank:]]\{1,\}/;/g' | cut -d ';' -f 1); do
    thu_file_time[$i]=$(echo $line)
    #echo "${thu_file_time[$i]}"
    i=$(($i+1))
done
n_thu=$i

i=0
for line in $(cat $thu_list | sed 's/[[:blank:]]\{1,\}/;/g' | cut -d ';' -f 2); do
    file_name[$i]=$(echo $line)
    #echo "${thu_file_time[$i]}"
    i=$(($i+1))
done

i=0
for line in $(cat $esg_list | sed 's/[[:blank:]]\{1,\}/;/g' | cut -d ';' -f 1); do
    esg_file_time[$i]=$(echo $line)
    #echo "${esg_file_time[$i]}"
    i=$(($i+1))
done
n_esg=$i

if [ $n_esg -ne $n_thu ]; then
    echo "WARNING: number of lines in esg-list /= thu-list: $n_esg /= $n_thu"
fi

flag=0
for ((i=0;i<$n_esg;i++)); do
    thu_line=$(cat $thu_list | /bin/grep ${file_name[$i]} )
    thu_time=$(echo $thu_line | sed 's/[[:blank:]]\{1,\}/;/g' | cut -d ';' -f 1)
    if [ ${esg_file_time[$i]} -lt $thu_time ]; then
        echo "error: THU is latter: " ${file_name[$i]}, "date: " ${esg_file_time[$i]}-${thu_time}
        flag=1
    fi
done
if [ $flag -eq 0 ]; then
    echo "CHECK SUCCESS! (no error meets)"
fi


