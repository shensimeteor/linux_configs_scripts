#!/bin/bash
#usage, mv_mg_dir.sh <src_dir>  <dest_dir>
#function, mv the whole <src_dir> to <dest_dir>, merge dir if necessary
#note:
#1. if a dir/file not exist in dest_dir, mv it
#2. if a dir exist in dest_dir, merge it
#3. if a file exist in dest_dir, ignore it

#$1, src_dir, $2, dest_dir
function move_and_merge(){
    local src=$1
    local dest=$2
    if [ ! -e $dest ]; then
        mv $src $dest
        echo mv $src $dest -----
    else
        if [ -d $src ]; then
            for child in $(ls $src/); do
                move_and_merge $src/$child $dest/$child
            done
        else
            echo "file-conflicts: $src, $dest ----"
        fi
    fi
}

move_and_merge $1 $2
echo "Finish!"
