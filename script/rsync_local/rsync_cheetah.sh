#!/bin/bash

dest=/media/sish3896/backup/
test -d $dest/data_disk_backup || mkdir -p $dest/data_disk_backup
rsync -avr  --delete --exclude-from="/home/sish3896/script/rsync_local/exclude_cheetah.txt"  /data/ $dest/data_disk_backup/
