#!/bin/bash
#ncrcat_date_files.sh <prefix> <postfix> <startdate> <enddate> <datebit> <output_file_name>
narg=$#
if [ $narg -ne 6 ]; then
    echo "<usage>: $0 <prefix> <postfix> <startdate> <enddate> <datebit> <output_file_name>"
    exit 2
fi
prefix=$1
postfix=$2
startdate=$3
enddate=$4
datebit=$5
output_file_name=$6





