#!/bin/bash
# diff all files specified in a list file
narg=$#
if [ $narg -ne 2 ]; then
    echo "<usage> $0 file_list1 file_list2"
    exit 2
fi

list1=$1
list2=$2
n1=$(cat $list1 | wc -l)
n2=$(cat $list2 | wc -l)

if [ ! -e $list1 ]; then
    echo "ERROR: $list1 not exist!"
    exit 2
fi
if [ ! -e $list2 ]; then
    echo "ERROR: $list2 not exist!"
    exit 2
fi    
if [ $n1 -ne $n2 ]; then
    echo "ERROR: list1 & list2 have different lines of row"
    exit 2
fi

paste $list1 $list2 > .temp_diffall
while read file1 file2; do
    base1=$(basename $file1)
    base2=$(basename $file2)
    if [ "$base1" != "$base2" ]; then
        read -a ans -p "WARN: The corresponding line: $file1  $file2 , seems not matching. Do you want continue? [Y/n]"
        if [ "$ans" == "n" ]; then
            exit 2
        fi
    fi
    echo diff $file1 $file2 
    diff $file1 $file2
done  < .temp_diffall
rm -rf .temp_diffall

