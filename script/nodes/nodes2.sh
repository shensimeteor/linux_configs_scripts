#!/bin/bash
# --------------------------------------------------------------------------
# Description:
#
#   a tool to get nodes's CPU load/ memory useage/ log on users/ accessibility 
#
# History:
#
#   2014-07-18:       [shensi]: First creation.
#   2014-07-21:       [shensi]: add to get nodes' working-on users(occupy CPU)
#                               not to release, because always print you(because you ssh "..")
# --------------------------------------------------------------------------

#test ping $1
function ping_test(){
    iserror=$(ping $1 -c 1 | /bin/grep -e "error")
    test -z "$iserror" && echo 1 || echo 0
}

#get this dir (where the sh file exists), input $1=file path
function get_this_dir(){
    cd $(dirname $1) && pwd
}

function help(){
   cat << EOF
**********************
[HELP of nodes]
   <HOSTNAME> the name of node
   <NCPU>  number of CPU(cores) of that node
   <LOADs>  load averages for the past 1, 5, and 15 minutes (the lower the better)
   <MEMTOT> total memory of that node
   <MEMUSE> used memory of that node
   <Log ons> Users who log on that node currently
   <Work ins> Users who now occupy the CPU of that node
   Tips : Use Ctrl + C when no response and try nodes later.
**********************
EOF
}

if [ $# -eq 1 ] && [ "$1" == "-h"  ]; then
   help
   exit
fi

dir_this=$(get_this_dir $0)
file_list=$dir_this/nodes.list
file_user=$dir_this/users.list

str_no_access="NOT ACCESSIBLE"
str_ssh_fail="SSH FAIL"
NCPU=8 ##

echo "HOSTNAME      NCPU        LOADs(1m,5m,15m)     MEMTOT   MEMUSE   Log-ons        Work-ins"
for node in $(cat $file_list); do
    if [ $(ping_test $node) -eq 0 ]; then
        printf "%s\t %s\n" $node  "$str_no_access---------------"
        continue
    fi
    uptimestr=$(ssh $node "uptime" 2>/dev/null)
    if [ $? -ne 0 ]; then
        printf "%s\t %s\n" $node  "$str_ssh_fail----------------"
        continue
    fi
    LOADs=$(echo $uptimestr | sed 's/^.*average://g')
    freestr=$(ssh $node "free -g | /bin/grep -ie Mem " 2>/dev/null)
    if [ $? -ne 0 ]; then
        printf "%s\t %s\n" $node  "$str_ssh_fail----------------"
        continue
    fi
    MEMTOT=$(echo $freestr | cut -d ' ' -f 2)
    MEMUSE=$(echo $freestr | cut -d ' ' -f 3)
    Users=$(ssh $node "who | tr -s ' ' | cut -d ' ' -f 1 | sort | uniq" 2>/dev/null)
    if [ $? -ne 0 ]; then
        printf "%s\t %s\n" $node  "$str_ssh_fail----------------"
        continue
    fi
    Users=$(echo $Users | sed 's/ /,/g')
    Workers=$(ssh $node " ps aux | tr -s ' ' | cut -d ' ' -f 1 | sort | uniq ")
    if [ $? -ne 0 ]; then
        printf "%s\t %s\n" $node  "$str_ssh_fail----------------"
        continue
    fi
    exp=""
    for user in $(cat $file_user); do
        exp=$exp" -e $user"
    done
    #echo "$exp"
    User_Workers=$(echo $Workers | tr ' ' '\n' | /bin/grep $exp )
    printf "%s\t\t %s\t %s\t %s\t %s\t %s\t %s\n" $node $NCPU "$LOADs" $MEMTOT"G" $MEMUSE"G" "$Users" "$User_Workers"
done
