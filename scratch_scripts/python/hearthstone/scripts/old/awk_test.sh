#!/bin/bash

time_start=01:04:36.38289
time_end=01:10:01.9715000
#ddfoo=$(date -d "time_start "1970-01-01 $old_hour:$old_min:00" +%s")
#echo $foo

echo `date --date="5 seconds ago"`
time_start2=`echo $time_start | cut -d"." -f1`
IFS=: read start_hour start_min start_second <<< "$time_start2"
echo $start_hour $start_min $start_second




#echo "$((10-5))"
#awk '$2 >= "'${time_start}'" && $2 <= "'${time_end}'"' /Applications/Hearthstone/Logs/Zone.log
#awk -v "START=$time_start" '$2 >= "START" && $2 <= "01:10:01.9715000"' /Applications/Hearthstone/Logs/Zone.log
