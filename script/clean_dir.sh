#!/bin/bash
narg=$#
if [ $narg -eq 2 ]; then
    dir=$1
    num=$2
    force=0
elif [ $narg -eq 3 ] && [ $1 == "-f" ]; then
    dir=$2
    num=$3
    force=1
else
    echo "<usage> $0 [-f] <dir> <number of subdir/file to leave>"
    exit 2
fi

files=($(ls $dir))
nfile=${#files[@]}

n_delete=$(($nfile - $num))

list=""
for ((i=0;i<$n_delete;i++)); do
    if [ $force -eq 1 ]; then
        echo "rm $dir/${files[$i]}"
        rm -rf $dir/${files[$i]}
    else
        echo "to rm: $dir/${files[$i]}"
        list="$list $dir/${files[$i]}"
    fi
done
if [ $force -eq 0 ]; then
    read -p "to continue removing? [Y/n]" ans
    if [ "$ans" == "Y" ] || [ "$ans" == "y" ]; then
        rm -rf $list
    fi
fi
