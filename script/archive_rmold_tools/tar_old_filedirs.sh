#!/bin/bash
#usage: tar_old_filedirs.sh [-option for tar, default -cf] nday dir_input dir_tar rm_origin_or_not(0/1)
#if nday <0, means all file
opt=""
suffix=".tar"
while [ 1 == 1 ]; do
    echo $1
    if [[ $1 == -* ]]; then
        echo 123
        opt="$opt $1"
        if [[ $1 == -*j* ]] || [ $1 == "--bzip2" ]; then
            suffix=".tar.bz"
        elif [[ $1 == -*z* ]] || [ $1 == "-gzip" ]; then
            suffix=".tar.gz"
        fi
    else
        break
    fi
    shift 1
done
if [ -z "$opt" ]; then
    opt="-cf"
fi

if [ $# -lt 4 ]; then
    echo "<usage>  [-option for tar command, default -cf]  <nday>  <dir_input>  <dir_tar_output> <to_rm_origin_or_not>"
    exit 2
fi
echo $opt
echo $@

nday=$1
dir_input=$2
dir_tar=$3
to_rm=$4
test -d $dir_tar || mkdir -p $dir_tar
cd $dir_input
if [ $nday -lt 0 ]; then
    files=$(find . -maxdepth 1)
else
    files=$(find . -maxdepth 1 -mtime +$nday)
fi
echo $files
for file in $files; do
    if [ $file == "." ] || [ $file == ".." ]; then
        continue
    fi
    fbase=$(basename $file)
    tar $opt $dir_tar/${fbase}$suffix $file
    if [ to_rm -eq 1 ] && [ -e $dir_tar/${fbase}${suffix} ]; then
        rm -rf $file
    fi
done

