#!/bin/bash

if [ "$#" -ne 1 ] && [ "$#" -ne 2 ] ; then
    echo "<Usage>: ./construct_gm4dvar_h.sh <name of your dir to construct> {-m | means only m4dv is need}"
    exit
fi

only_m4dv=$(echo $* | /bin/grep "\-m"  ) ##all is needed if emtpy, otherwise only m4dv
dirnamex=$(echo $* | sed 's/\-m//g')
dirname=$(echo $dirnamex)

ORIGIN_DIR=/snfs01/shensi/GRAPES_GFS/grapes/grapes_4dv_zhangh/

if [ -n "$only_m4dv" ]; then ## only m4dv
    echo "construct m4dv: $dirname from $ORIGIN_DIR----"
    mkdir -p $dirname/rundir/output
    ln -sf $ORIGIN_DIR/m4dv/rundir/4dvar_h.exe $dirname/rundir/
    ln -sf $ORIGIN_DIR/m4dv/rundir/{albedo,topography,*.TBL,RRTM_DATA} $dirname/rundir/
    cp $ORIGIN_DIR/m4dv/rundir/{namelist.4dvar,namelist.input,namelist_h.input} $dirname/rundir
else
    echo "construct m4dv+data $dirname from $ORIGIN_DIR----"
    mkdir -p $dirname/m4dv/rundir/output
    ln -sf $ORIGIN_DIR/m4dv/rundir/4dvar_h.exe $dirname/m4dv/rundir/
    ln -sf $ORIGIN_DIR/m4dv/rundir/{albedo,topography,*.TBL,RRTM_DATA} $dirname/m4dv/rundir/
    cp $ORIGIN_DIR/m4dv/rundir/{namelist.4dvar,namelist.input,namelist_h.input} $dirname/m4dv/rundir

    mkdir -p $dirname/data/output/check
    cp -r $ORIGIN_DIR/data/{CVS,*.dat} $dirname/data/
    for dir in $(/bin/ls -d  $ORIGIN_DIR/data/input/*); do
        mkdir -p $dirname/data/input/$(basename $dir)
    done
    cp -r $ORIGIN_DIR/data/input/{backgrd,be,blacklist,CVS,rmsdata,rt7para,rtcoef} $dirname/data/input/
fi



