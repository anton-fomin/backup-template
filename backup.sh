#!/bin/bash
set -e
set -o pipefail

BACKUP_DIR=tmp
ITEMS_LEFT=15


function doBackup {
	local filename=$1
	touch $BACKUP_DIR/$filename
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

echo "Doing backup"
doBackup $(backupTime)
echo "Done"
cleanUp
