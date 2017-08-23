#/usr/bin/bash

pgrep tail | xargs kill

tail -fn0 /Applications/Hearthstone/Logs/Power.log | \
while read line ; do
        echo "$line" | grep "CREATE_GAME"
        if [ $? = 0 ] 
          then
            date_tag=$(date +%F_%R)
            tail -f /Applications/Hearthstone/Logs/Zone.log | grep "NUM_CARDS_DRAWN_THIS_TURN\|OPPOSING PLAY\| FRIENDLY PLAY" >>  ~/github/scratch_scripts/python/hearthstone/parsed_logs/"parsed_log.$date_tag" &
            echo `pgrep -f "Zone.log"`
            echo "Log $date_tag is rollin'!"
          fi
        echo "$line" | grep "brbcoffee tag=PLAYSTATE value=WON\|brbcoffee tag=PLAYSTATE value=LOST"
        if [ $? = 0 ]
          then
            echo "Game Over - killing above tail"
            sleep 10
            mv /Users/ericyoung/github/scratch_scripts/python/hearthstone/scripts/logs_for_processing/* /Users/ericyoung/github/scratch_scripts/python/hearthstone/scripts/old
            awk '!seen[$0]++' ~/github/scratch_scripts/python/hearthstone/parsed_logs/"parsed_log.$date_tag" | grep -v "DirtyZones\|waiting for zone\|OPPOSING HAND\|FRIENDLY HAND\| GRAVEYARD\|TAG_CHANGE" > /Users/ericyoung/github/scratch_scripts/python/hearthstone/scripts/logs_for_processing/"scrubbed_log.$date_tag"
            for i in `pgrep -f "Zone.log"`; do kill $i; done
            echo $line >> ~/github/scratch_scripts/python/hearthstone/parsed_logs/"parsed_log.$date_tag"
        fi
    done
