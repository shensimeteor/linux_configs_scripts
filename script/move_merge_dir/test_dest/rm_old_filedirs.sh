#!/bin/bash
#usage <rm_old_filedirs.sh>  <days, mod.date before which to delete>  <option; -f: force; -n:no delete, only print> <files_or_dirs>
narg=$#
if [ $narg -lt 2 ]; then
    echo "<usage>: $0, <days>  [ | -f | -n] <file_or_dir_1> [<file_or_dir_2> ...]"
    exit 2
fi
nday=$1
shift 1
if [ "$1" == "-f" ]; then
    force=1
    shift 1
elif [ "$1" == "-n" ]; then
    nodel=1
    shift 1
else
    force=0
    nodel=0
fi

function get_mod_date() {
    item=$1
    datex="$(stat $item | grep '^[Mm]odify:' | sed 's/^[Mm]odify: *//g' | cut -d '.' -f 1)"
    echo "$datex"
}

#date1 - date2 = diff_hour, format of date: can be recognized by cmd: date
function date_diff_hours() {
    sec1=$(date -d "$1" +%s)
    sec2=$(date -d "$2" +%s)
    diff=$(($sec1 - $sec2))
    diff_hour=$(( $diff / 3600 ))
    echo $diff_hour
}

now="$(date)"
keep_hour=$(echo "$nday * 24" | bc)
while [ 1 -eq 1 ]; do
    if [ $# -eq 0 ]; then
        break
    fi
    datex="$(get_mod_date $1)"
    diffhr=$(date_diff_hours "$now" "$datex")
    if [ $(echo "$diffhr > $keep_hour" | bc) -eq 1 ]; then
        if [ $nodel -eq 1 ]; then
            echo "$1"
        elif [ $force -eq 1 ]; then
            rm -rf $1
        else 
            rm -ir $1
        fi
    fi
    shift 1
done

