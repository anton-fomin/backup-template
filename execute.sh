#!/bin/bash
SCRIPT=$1

SUBJECT=$2
EMAIL_TO=$3

if [ -f settings.sh ]; then
  source settings.sh
fi
#echo "$0 $*"

alreadyRunning=`pgrep -af "$0 $*" -c`

if [ $alreadyRunning -gt 3 ];
then
  echo "To many processes already running. Sending email to $EMAIL_TO"
  echo "Too many $0 $* running." | /usr/bin/sendemail -f $FROM -t "$EMAIL_TO" -u "Too many $SCRIPT running." -s $SMTP -xu $SMTP_LOGIN -xp $SMTP_PASS
  exit 1
fi


LOG=`bash -x $SCRIPT 2>&1`
RESULT=$?
echo "$LOG"
#echo "$RESULT"

if [ $RESULT -ne "0" ];
then
  echo "Execution failed. Sending email to $EMAIL_TO"
  echo "$LOG" | /usr/bin/sendemail -f $FROM -t "$EMAIL_TO" -u "Execution of $SCRIPT failed." -s $SMTP -xu $SMTP_LOGIN -xp $SMTP_PASS
fi

