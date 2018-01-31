#!/bin/bash
#1. record accounts
test -e $DIR_SSH_UTILS/accounts || touch $DIR_SSH_UTILS/accounts
for para in $@; do
    if [ -n "$(echo $para | grep @)" ]; then
        host=$(echo $para | cut -d ':' -f 1)
        if [ -n "$(cat $DIR_SSH_UTILS/accounts | /bin/grep ^$host$)" ]; then
            continue
        fi
        read -p "To record $host in accounts?[Y/n]" x
        test "$x" == "n" -o "$x" == "N" || echo $host >> $DIR_SSH_UTILS/accounts
    fi
done
#2. scp
/usr/bin/scp $@


