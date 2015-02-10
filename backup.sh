#!/bin/bash
set -e
set -o pipefail

BACKUP_DIR=tmp
ITEMS_LEFT=15
LOCKFILE=/tmp/backup.lock
WAIT_TIMEOUT=30

function doBackup {
	local filename=$1
	sleep 30
	touch $BACKUP_DIR/$filename
#		pg_basebackup -D $BACKUP_DIR/$filename -x -F tar -z -v
}

function cleanUp {
	local dir=$BACKUP_DIR
	local total_items=`ls -1 $dir | wc -l`
	if [ $total_items -gt $ITEMS_LEFT ];
	then
		local items_to_delete=`expr $total_items - $ITEMS_LEFT`
		local old_dir=`pwd`
    echo "Deleting"
		ls -1 $dir | head -n $items_to_delete
		cd $dir
		rm -rf `ls -1 | head -n $items_to_delete`
		cd $old_dir
    echo "Clean up complete"
	fi
}

function backupTime {
	local format="%Y-%m-%d_%H:%M:%S"
	local date=`/bin/date +$format`
	echo $date
}

(
flock -x -w $WAIT_TIMEOUT 99
echo "Doing backup"
doBackup $(backupTime)
echo "Done"
cleanUp
) 99>$LOCKFILE