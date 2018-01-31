#!/bin/bash
# for a error soft link file (i.e. the original path is not exist), relink it to the correct path
# need 2 environment vars set: FIND_STR, REPLACE_STR
# NOTICE:
# 1. all files/dirs in your reln search directories should NOT have blank (" ") in their names 
# 2. FIND_STR, REPLACE_STR should not have special characters (like \, *) except (. & / , the two basic)
# 3. if a soft link dir (dir -> dir1) in the search directories, do NOT dig into the linked dir!

if [ $# -eq 0 ]; then
    echo "<useage>: reln.sh [-r] <dirs/files> (plus: set FIND_STR & REPLACE_STR before)"
    echo "      -r: do recursivly: if meet a dir, dig into it"
    exit 2
fi

if [ -z "$FIND_STR" ] || [ -z "$REPLACE_STR" ]; then
    echo "you need to set FIND_STR & REPLACE_STR before run this script"
    exit 2
fi
test_sc=$(echo $FIND_STR | fgrep -e '*' -e '@' -e '?' -e '$' -e '~' -e '\\' -e ' ')
if [ -n "$test_sc" ]; then
    echo "FIND_STR=$FIND_STR wrong, because it has special characters"
    exit 2
fi
test_sc=$(echo $REPLACE_STR | fgrep -e '*' -e '@' -e '?' -e '$' -e '~' -e '\\' -e ' ')
if [ -n "$test_sc" ]; then
    echo "REPLACE_STR=$REPLACE_STR wrong, because it has special characters"
    exit 2
fi

narg=$#
do_recur=0
declare -a objs
objs=()
cnt=0
for ((i=1; i<=$narg; i=i+1)); do
    if [ "$1" == "-r" ]; then
        do_recur=1
        continue
    fi
## check for special characters
    test_sc=$(echo $1 | fgrep -e '*' -e '@' -e '?' -e '$' -e '~' -e '\\' -e ' ')
    if [ -n "$test_sc" ]; then
        echo "file/dir: $1 skiped, because it has special characters in its name"
        continue
    fi
    objs[$cnt]=$1
    let cnt=cnt+1
    shift
done


function func_reln_dir()
{
    local dir
    local do_recur
    local deep
    local wd
    wd=$(pwd)
    dir=$1
    do_recur=$2
    deep=$3
    let deep=deep+1
    find_str_x=$(echo $FIND_STR | sed 's/\//\\\//g')
    replace_str_x=$(echo $REPLACE_STR | sed 's/\//\\\//g')
    for item in $(/bin/ls $dir); do
     #   echo "$deep--meet item:$dir/$item"
        if [ -L "$dir/$item" ]; then ## item can be soft link file or dir
     #       echo "$deep--$dir/$item is a link"
            org_path=$(/bin/ls -ld $dir/$item | sed 's/^.* //g')
            org_path_x=$(echo $org_path | sed 's/\//\\\//g')
      #      echo $org_path
            new_path_x=$(echo "$org_path_x" | sed "s/$find_str_x/$replace_str_x/g")
            new_path=$(echo $new_path_x | sed 's/\\\//\//g')
            if [ ! -e "$new_path" ]; then
                echo "new_path=$new_path not exist! skip it"
                continue
            fi
    #        echo "relink: $item: $org_path => $new_path"
            cd $dir
            ln -sf $new_path $item
            cd $wd
        elif [ -d "$dir/$item" ]; then
       #     echo "$deep--$item is a link dir: dig into it"
            if [ $do_recur -eq 1 ]; then
                func_reln_dir "$dir/$item" $do_recur $deep
            fi
        fi
    done
}

            

find_str_x=$(echo $FIND_STR | sed 's/\//\\\//g')
replace_str_x=$(echo $REPLACE_STR | sed 's/\//\\\//g')
for ((i=0; i<${#objs[@]}; i=i+1)); do
    item=${objs[$i]}
    if [ -L "$item" ]; then
        org_path=$(/bin/ls -ld $item | sed 's/^.* //g')
        org_path_x=$(echo $org_path | sed 's/\//\\\//g')
        new_path_x=$(echo "$org_path" | sed "s/$find_str_x/$replace_str_x/g")
        new_path=$(echo $new_path_x | sed 's/\\\//\//g')
        echo "relink: $item: $org_path => $new_path"
        ln -sf $new_path $item
##
    elif [ -d "$item" ] && [ $do_recur -eq 1 ]; then
        func_reln_dir "$item" $do_recur 0
    fi
done
        


