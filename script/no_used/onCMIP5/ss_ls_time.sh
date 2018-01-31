#!/bin/bash
# will output lists named as timelist_<expt_name>_<freq>_<realm>_<rip>
if [ $# -ne 1 ]; then
    echo "usage: ./ss_ls_time.sh <expt_dir>"
    echo "e.g. ./ss_ls_time.sh /esgdata/CMIP5/output/LASG-CESS/FGOALS-g2/1pctCO2"
    exit
fi
CWD=$(pwd)
expt_name=$(basename $1)
echo $expt_name
cd $1
for freq in $(/bin/ls .); do
    test -d $freq || continue
    cd $freq
    for realm in $(/bin/ls .); do
        test -d $realm || continue
        cd $realm
        first=1
        for var in $(/bin/ls .); do
            test -d $var || continue
            cd $var
            for rip in $(/bin/ls .); do
                test -d $rip || continue
                filename=$CWD/timelist_${expt_name}_${freq}_${realm}_${rip}
                if [ $first -eq 1 ]; then
                    test -e $filename && rm $filename
                fi
                /bin/ls -l --full-time $rip | sed 's/[[:blank:]]\{1,\}/;/g' | cut -d ';' -f 6,7,9 | sed 's/\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\)/\1\2\3/g' | sed 's/;.*;/  /g' \
                >>$filename
            done
            first=0
            cd ..
        done
        cd ..
    done
    cd ..
done
