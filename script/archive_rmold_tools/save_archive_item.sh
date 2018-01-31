#!/bin/bash
# ./save_archive <dir to archive> <date, equal to or before which is to archive> <archive dir> <archive depth, 1 or 2>
# archive automatically in forms : <archive dir>/{yyyymm,yyyymm/dd}/<original_files>
# note: 1. only files/dirs whose names containing 2YYYMMDD, 2YYYMMDDHH, 2YYYMMDDHHmm are recognized, and only one of the forms exist
#       2. can not run on Mac OS, only Linux (due to date command difference between Mac & Linux)

declare -a datefiles 
declare -a filedates
ans_ls_datefiles="" #will be modified in ls_datefiles
#get datefiles (array) & filedates (array): global vars
function ls_datefiles(){
    local cnt files12 files10 files08 file
    cnt=0
    files12=$(ls | egrep 2[[:digit:]]\{11,11\}) #2YYYMMDDHHmm
    if [ -n "$files12" ]; then
        for file in $files12; do
            datefiles[$cnt]=$file
            filedates[$cnt]=$(echo $file | sed 's/.*\(2[0-9]\{11,11\}\).*/\1/g')
            cnt=$(($cnt+1))
        done
        return
    fi
    files10=$(ls | egrep 2[[:digit:]]\{9,9\} )  #2YYYMMDDHH
    if [ -n "$files10" ]; then
        for file in $files10; do
            datefiles[$cnt]=$file
            filedates[$cnt]=$(echo $file | sed 's/.*\(2[0-9]\{9,9\}\).*/\1/g')
            cnt=$(($cnt+1))
        done
        return
    fi
    files08=$(ls | egrep 2[[:digit:]]\{7,7\})  #2YYYMMDD
    if [ -n "$files08" ]; then
        for file in $files08; do
            datefiles[$cnt]=$file
            filedates[$cnt]=$(echo $file | sed 's/.*\(2[0-9]\{7,7\}\).*/\1/g')
            cnt=$(($cnt+1))
        done
        return
    fi
    ans_ls_datefiles="Fail"
}

#input: filename, 1: filename, 2:datelength(e.g., 8 for yyyyddmm, 10 for yyyyddmmhh, 12 for yyyyddmmhhMM
function get_file_namedate(){
    fbase=$(basename $1)
    nm1=$(($2 - 1))
    date1=$(echo $fbase | sed 's/.*\(2[0-9]\{$nm1,$nm1\}\).*/\1/g')
    echo $date1
}



#date as YYYYMMDD / YYYYMMDDHH / YYYYMMDDHHmm
function date_to_second() {
    local xdate sec yr mo dy hr mn
    xdate=$1
    yr=$(echo $xdate | cut -c 1-4)
    mo=$(echo $xdate | cut -c 5-6)
    dy=$(echo $xdate | cut -c 7-8)
    hr=$(echo $xdate | cut -c 9-10)
    mn=$(echo $xdate | cut -c 11-12)
    if [ ${#xdate} -eq 8 ]; then
        sec=$(date -d "$yr$mo$dy 00:00:00" +%s) 
    elif [ ${#xdate} -eq 10 ]; then
        sec=$(date -d "$yr$mo$dy $hr:00:00" +%s)
    elif [ ${#xdate} -eq 12 ]; then
        sec=$(date -d "$yr$mo$dy $hr:$mn:00" +%s)
    else 
        echo "Fail"
        return
    fi
    if [ $? -ne 0 ]; then
        echo "Fail"
    fi
    echo $sec
}
        


# read args
narg=$#
if [ $narg -ne 4 ]; then
    echo "$0 <date_length> <archive dir > <archive depth, 1/2> -f <files>"
    exit 2
fi
file=$1
datelen=$2
output_dir=$3
depth=$4
if [ $depth -ne 1 ] && [ $depth -ne 2 ]; then
    echo "depth should be either 1 (yyyymm) or 2 (yyyymm/dd)"
    exit 2
fi

date_file=$(get_file_namedate $file $datelen)

for ((i=0;i<$nfile;i++)); do
    xsec=$(date_to_second ${filedates[$i]})
    if [ "$xsec" == "Fail" ]; then
        echo "Fail to recognized: ${filedates[$i]} from ${datefiles[$i]}"
        exit 2
    fi
    if [ $xsec -le $sec_max_date ]; then
        yrmo=$(echo ${filedates[$i]} | cut -c 1-6)
        dy=$(echo ${filedates[$i]} | cut -c 7-8)
        if [ $depth -eq 1 ]; then
            test -d $output_dir/$yrmo || mkdir -p $output_dir/$yrmo
            mv ${datefiles[$i]} $output_dir/$yrmo/
        elif [ $depth -eq 2 ]; then
            test -d $output_dir/$yrmo/$dy || mkdir -p $output_dir/$yrmo/$dy
            mv ${datefiles[$i]} $output_dir/$yrmo/$dy/
        fi
    fi
done    
