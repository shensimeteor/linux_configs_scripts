#!/bin/bash

# Written by Li Dong. You can delete it, if it is no use for you.

root="/esgdata/CMIP5/output/LASG-CESS/FGOALS-g2/amip"

dirs=""
for dir in $(echo 3hr 6hr day); do
    dirs="$dirs $(find $root/$dir -type d -name '*r*i*p*')"
done

for dir in $(echo $dirs); do
    echo "[Notice]: Change to $dir"
    cd $dir
    for file in $(ls $dir); do
        echo -n "$file: " 1>&2
        sum $file 1>&2
    done
done
