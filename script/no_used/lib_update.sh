#!/bin/bash
n_file=$#
if [ $n_file -eq 0 ]; then
    echo "usage: ./lib_update.sh <file 1 to be update> <file2 to be update> .."
    exit
fi
LIB_ROOT=$HOME/SS_LIB
test -d $LIB_ROOT/old_versions || mkdir -p $LIB_ROOT/old_versions
for file in $@; do 
   file_name=$(basename $file)
   if [ -e $LIB_ROOT/$file_name ]; then
       f_date=$(stat $file | /bin/grep Modify | sed 's/^Modify:[[:blank:]]*//g' | cut -d '.' -f 1) 
       lib_date=$(stat $LIB_ROOT/$file_name | /bin/grep Modify | sed 's/^Modify:[[:blank:]]*//g' | cut -d '.' -f 1)
       read -p "overwrite ss_lib/$file_name? (f: $f_date; lib: $lib_date) [Y/n]" x
       if [ "$x" == "Y" ] || [ "$x" == "y" ]; then
           mv $LIB_ROOT/$file_name $LIB_ROOT/old_versions/
           cp -r $file $LIB_ROOT
           echo "have updated $file to ss_lib/$file_name ========"
       fi
   else
       cp -r $file $LIB_ROOT
       echo "have updated $file to ss_lib/$file_name ========"
   fi
done
