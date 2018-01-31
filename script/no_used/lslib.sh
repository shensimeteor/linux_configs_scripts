#!/bin/bash
# shensi; find the lib file: $1 in your LD_LIBRARY_PATH;
# usage: lslib.sh libnetcdf
lib_path=$LD_LIBRARY_PATH
lib_path=$(echo $lib_path | sed 's/:/  /g')
for path in $lib_path; do
    files=$(/bin/ls -l $path/$1* 2>/dev/null | sed 's/[[:blank:]]\{1,\}/;/g' | cut -d ';' -f 9- )
    for file in $files; do
        echo $(echo $file | sed 's/;/ /g') | grep --color $1
    done
done
