#/usr/bin/bash

pgrep tail | xargs kill

tail -fn0 /Applications/Hearthstone/Logs/Power.log | \
while read line ; do
        echo "$line" | grep "CREATE_GAME"
        if [ $? = 0 ] 
          then
            date_tag=$(date +%F_%R)
            tail -f /Applications/Hearthstone/Logs/Zone.log /Applications/Hearthstone/Logs/Power.log| grep "tag=TURN value=\|GameState.DebugPrintPower()\ -\ TAG_CHANGE\ Entity=.*\|ZoneChangeList.ProcessChanges()\ -\ TRANSITIONING\ card\|TAG_CHANGE\ Entity=brbcoffee\ tag=PLAYSTATE\ value=" >>  ~/github/scratch_scripts/python/hearthstone/parsed_logs/"parsed_log.$date_tag" &
            echo `pgrep -f "Zone.log"`
            echo "Log $date_tag is rollin'!"
          fi
        echo "$line" | grep "FINAL_WRAPUP"
        if [ $? = 0 ]
          then
            echo "Game Over - killing above tail"
            awk '!seen[$0]++' ~/github/scratch_scripts/python/hearthstone/parsed_logs/"parsed_log.$date_tag" > ~/github/scratch_scripts/python/hearthstone/parsed_logs/"scrubbed_log.$date_tag"
            for i in `pgrep -f "Zone.log"`; do kill $i; done
        fi
    done
