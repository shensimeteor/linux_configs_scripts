#!/bin/bash

narg=$#
if [ $narg -eq 0 ]; then
    echo "[USAGE]: $1 files_to_relink"
    exit 2
fi

while [ $# -gt 0 ]; do
    file=$1
    if [ -s 

