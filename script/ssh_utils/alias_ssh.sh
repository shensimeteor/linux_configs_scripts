#!/bin/bash
#1. write down LASTDIR
echo export LASTDIR=$(pwd) > $DIR_SSH_UTILS/.ssh_lastdir
test -e $DIR_SSH_UTILS/accounts || touch $DIR_SSH_UTILS/accounts
#2. record accounts
for para in $@; do
    if [ -n "$(echo $para | grep @)" ]; then
        if [ -n "$(cat $DIR_SSH_UTILS/accounts | /bin/grep ^$para$)" ]; then
            continue
        fi
        read -p "To record $para in accounts?[Y/n]" x
        test "$x" == "n" -a "$x" == "N" || echo $para >> $DIR_SSH_UTILS/accounts
    fi
done
#3. ssh
/usr/bin/ssh $@


