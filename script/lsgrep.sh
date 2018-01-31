#!/bin/bash
# shensi 

if [ $# -ne 2 ] && [ $# -ne 3 ]; then
    echo "run as: lsgrep.sh <dir to descend into> <keyword> [<maxlevel>] "
    exit
fi

wd=$(pwd)


if [ "$1" == "." ]; then
    cd ..
    rootdir=$(pwd)
    node=$(basename $wd)
else
    rootdir=$(pwd)
    node=$1
fi

if [ $# == 2 ]; then
    max_level=99999
else
    max_level=$3
fi
level=0

function func_lsgrep()
{
    local node
    local subnode
    local keyword
    local prntdir
    node=$1
    keyword=$2
    prntdir=$3
    
    if [ -n "$(echo $node | grep "$keyword")" ]; then
        echo -n $prntdir: 
        echo $node | grep --color "$keyword"
    fi
    if [ $level -lt  $max_level ]; then
       level=$(($level+1))
       if [ -d $rootdir/$prntdir/$node ]; then
           for subnode in $(ls $rootdir/$prntdir$node ); do
               func_lsgrep "$subnode" "$keyword" "$prntdir$node/"
           done
       fi
       level=$(($level-1))
    fi
}

#echo func_lsgrep  "$node" "$2" ""

func_lsgrep  "$node" "$2" ""

            



