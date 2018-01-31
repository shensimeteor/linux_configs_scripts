#!/bin/bash

if [ $# -ne 1 ]; then
    echo "usage: construct_modelrun.sh <dir name of your construct>"
    exit
fi
dirname=$1

ORIGIN_DIR=/snfs01/shensi/GRAPES_GFS/grapes/MODEL/RUN


mkdir $dirname

cp $ORIGIN_DIR/{colm.nml,*.TBL,rrtmg.nml} $dirname/
cd $dirname
ln -sf $ORIGIN_DIR/albedo albedo
cp $ORIGIN_DIR/gwddat gwddat
ln -sf $ORIGIN_DIR/ozone.nc ozone.nc
ln -sf $ORIGIN_DIR/RRTM_DATA RRTM_DATA
cp $ORIGIN_DIR/namelist.input .
mkdir -p CoLM/{rdata,odata,idata}
ln -sf $ORIGIN_DIR/CoLM/idata/soil.nc CoLM/idata/soil.nc
ln -sf $ORIGIN_DIR/CoLM/rdata/* CoLM/rdata/
ln -sf $ORIGIN_DIR/grapes_global.exe .

cat <<EOF
costruct Model Run from $ORIGIN_DIR successfully----
you should prepare sst.nc & modify namelist & prepare grapesinput yourself
EOF
