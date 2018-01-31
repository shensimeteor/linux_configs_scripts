#!/bin/bash
## USE ln -si instead of -sf
npara=$#
for ((i=0;i<$npara;i++)); do
    para=$1
    shift
done
if [ ! -d $para .and. -e $para]; then
    echo "Are you sure to remove $para to link?"
