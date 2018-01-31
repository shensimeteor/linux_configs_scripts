#!/bin/bash
# will output lists named as list_<expt_name>_<freq>_<realm>_<rip>
if [ $# -ne 1 ]; then
    echo "usage: ./ss_ls_sizetime.sh <expt_dir>"
    echo "e.g. ./ss_ls_sizetime.sh /esgdata/CMIP5/output/LASG-CESS/FGOALS-g2/1pctCO2"
    exit
fi
CWD=$(pwd)
expt_name=$(basename $1)
echo $expt_name
first=1
cd $1
for freq in $(/bin/ls .); do
    test -d $freq || continue
    cd $freq
    for realm in $(/bin/ls .); do
        test -d $realm || continue
        cd $realm
        for var in $(/bin/ls .); do
            test -d $var || continue
            cd $var
            for rip in $(/bin/ls .); do
                test -d $rip || continue
                filename=$CWD/list_${expt_name}_${freq}_${realm}_${rip}
                if [ $first -eq 1 ]; then
                    test -e $filename && rm $filename
                fi
                ls -l $rip/ | cut -d ' ' -f 5- >>$filename
            done
            first=0
            cd ..
        done
        cd ..
    done
    cd ..
done
