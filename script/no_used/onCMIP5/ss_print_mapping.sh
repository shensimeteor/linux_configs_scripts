#!/bin/bash
root=/esgdata/CMIP5/output/LASG-CESS/FGOALS-g2/

for expt in $(/bin/ls $root); do
    for freq in $(/bin/ls $root/$expt/); do
        realm=atmos
        example_var=$(/bin/ls $root/$expt/$freq/$realm | head -n 1)
        for rip in $(/bin/ls $root/$expt/$freq/$realm/$example_var); do
            test -d "$root/$expt/$freq/$realm/$example_var/$rip" || continue
            begin_yr_esg=$(/bin/ls $root/$expt/$freq/$realm/$example_var/$rip/ | head -n 1 |  cut -d '_' -f 6 | cut -c 1-4)
            end_yr_esg=$(/bin/ls $root/$expt/$freq/$realm/$example_var/$rip/ | tail -n 1 |  cut -d '_' -f 6 | cut -d '-' -f 2 | cut -c 1-4)
            echo "$expt,$freq,$rip,166.110.5.230, , , $root/$expt/$freq/$realm/*/$rip, $begin_yr_esg, $end_yr_esg" >> mapping.list
        done
    done
done
