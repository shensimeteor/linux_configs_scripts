#!/bin/bash

# Written by Li Dong. You can delete it, if it is no use for you.

root="/esgdata/CMIP5/output/LASG-CESS/FGOALS-g2/amip"

dirs=""
for dir in $(echo 3hr 6hr day subhr); do
    dirs="$dirs $(find $root/$dir -type d -name '*r*i*p*')"
done

for dir in $(echo $dirs); do
    echo "[Notice]: Change to $dir"
    cd $dir
    size=""
    for file in $(ls $dir); do
        size="$size $(du -sm $file | cut -f 1)\n" 
    done
    echo -e "$size" | uniq
done
