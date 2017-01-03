#/usr/bin/bash

echo "starting agent"
tail -fn0 /Applications/Hearthstone/Logs/Power.log | \
while read line ; do
        echo "$line" | grep "\- CREATE_GAME"
        if [ $? = 0 ] 
          then
            date_tag=$(date +%F_%R)
            time_start=`gdate --date="5 seconds ago" +%H:%M:%S`
            echo "Time start: $time_start"
            echo `pgrep -f "Zone.log"`
            echo "Log $date_tag is rollin'!"
          fi
        echo "$line" | grep "brbcoffee tag=PLAYSTATE value=WON\|brbcoffee tag=PLAYSTATE value=LOST"
        if [ $? = 0 ]
          then
            echo "Game Over - killing above tail"
            time_end=`tail -n1 /Applications/Hearthstone/Logs/Zone.log | cut -d" " -f2`
            echo "Time end: $time_end"
            echo "Log file: scrubbed_log.$date_tag"
            awk '$2 >= "'$time_start'" && $2 <= "'$time_end'"' /Applications/Hearthstone/Logs/Zone.log | grep -v "DirtyZones\|waiting for zone\|OPPOSING HAND\|FRIENDLY HAND\|GRAVEYARD" > /Users/ericyoung/github/scratch_scripts/python/hearthstone/scripts/logs_for_processing/"scrubbed_log.$date_tag"
            for i in `pgrep -f "Zone.log"`; do kill $i; done
            echo $line >> /Users/ericyoung/github/scratch_scripts/python/hearthstone/scripts/logs_for_processing/"scrubbed_log.$date_tag" 
        fi
    done
