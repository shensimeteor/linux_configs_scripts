#!/bin/bash
#cpout_date_plots.sh <dir_of_cycle> <name_or_wildcard_of_plot> <output_dir>
#to cp specified plot (by $2) of each date to <output_dir>, renamed as <date>_<plot>
narg=$#
if [ $narg -lt 3 ]; then
    echo "$0  <dir_of_cycle>  <name_or_wildcard_of_plot>  <output_dir>"
    exit 2
fi

cd $1
test -d $3 || mkdir -p $3
for date in $(ls 2* -d); do
    files=$(ls $date/$2)
    for file in $files; do
        basef=$(basename $file)
        cp $file $3/${date}_$basef
    done
done

