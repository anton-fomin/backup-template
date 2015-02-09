#!/bin/bash
SCRIPT=$1

SUBJECT=$2
TO=$3


LOG=`bash -x $SCRIPT 2>&1`
RESULT=$?
#echo "$LOG"
#echo "$RESULT"

if [ $RESULT -ne "0" ];
then
  echo "Execution failed. Sending email to $TO"
  echo "$LOG" | mail -s "$SUBJECT" $TO
fi

