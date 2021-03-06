#!/bin/bash

# Zabbix requested parameter
ZBX_REQ_DATA="$2"
ZBX_REQ_DATA_DEV="$1"

# source data file
SOURCE_DATA=/tmp/iostat/data/iostat.out

#
# Error handling:
#  - need to be displayable in Zabbix (avoid NOT_SUPPORTED)
#  - items need to be of type "float" (allow negative + float)
#
ERROR_NO_DATA_FILE="0.401"
ERROR_OLD_DATA="0.402"
ERROR_WRONG_PARAM="0.403"
ERROR_MISSING_PARAM="0.404"

# No data file to read from
if [ ! -f "$SOURCE_DATA" ]; then
  echo $ERROR_NO_DATA_FILE
  exit 1
fi

# Missing device to get data from
if [ -z "$ZBX_REQ_DATA_DEV" ]; then
  echo $ERROR_MISSING_PARAM
  exit 1
fi

#
# Old data handling:
#  - in case the cron can not update the data file
#  - in case the data are too old we want to notify the system
# Consider the data as non-valid if older than OLD_DATA minutes
#
OLD_DATA=5
if [ $(stat -c "%Y" $SOURCE_DATA) -lt $(date -d "now -$OLD_DATA min" "+%s" ) ]; then
  echo $ERROR_OLD_DATA
  exit 1
fi

# 
# Grab data from SOURCE_DATA for key ZBX_REQ_DATA
#
# 1st check the device exists and gets data 
device_count=$(grep -Ec "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA)
if [ $device_count -eq 0 ]; then
  echo $ERROR_WRONG_PARAM
  exit 1
fi

# 2nd grab the data from the source file
case $ZBX_REQ_DATA in
  rrqm/s)     grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $2}';;
  wrqm/s)     grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $3}';;
  r/s)        grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $4}';;
  w/s)        grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $5}';;
  rkB/s)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $6}';;
  wkB/s)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $7}';;
  avgrq-sz)   grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $8}';;
  avgqu-sz)   grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $9}';;
  await)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $10}';;
  svctm)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $11}';;
  %util)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $12}';;
  *) echo $ERROR_WRONG_PARAM; exit 1;;
esac

exit 0