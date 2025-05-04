#! /bin/bash

function check_online
{
  nmcli general | grep "^connected" >/dev/null && echo 1 || echo 0
}

# initial check to see if we are online
IS_ONLINE=$(check_online)
# init variable for loop
CHECKS=0
MAX_CHECKS=5

# loop check for online connectivity
while [ $IS_ONLINE -eq 0 ]; do
  sleep 10;

  IS_ONLINE=$(check_online)

  CHECKS=$[ $CHECKS + 1 ]
  if [ $CHECKS -gt $MAX_CHECKS ]; then
    break
  fi
done

if [ $IS_ONLINE -eq 0 ]; then
    exit 1
fi

# apparently we are online so run:
LOG_FILE="/var/log/yaziPluginUpdate.log"
echo "------------------------" >> $LOG_FILE
echo $(date +%s) >> $LOG_FILE
echo "updating packages..." >> $LOG_FILE
/usr/bin/ya pack --upgrade >> $LOG_FILE 2>&1
echo "finished updating" >> $LOG_FILE
echo "------------------------" >> $LOG_FILE
