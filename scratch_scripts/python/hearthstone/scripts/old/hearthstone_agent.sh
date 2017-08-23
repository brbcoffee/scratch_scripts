#/usr/bin/bash

pgrep tail | xargs kill

tail -fn0 /Applications/Hearthstone/Logs/Power.log | \
while read line ; do
        echo "$line" | grep "CREATE_GAME"
        if [ $? = 0 ] 
          then
            tail -f /Applications/Hearthstone/Logs/Zone.log /Applications/Hearthstone/Logs/Power.log| grep "tag=TURN value=\|GameState.DebugPrintPower()\ -\ TAG_CHANGE\ Entity=.*\|ZoneChangeList.ProcessChanges()\ -\ TRANSITIONING\ card\|BLOCK_START\ BlockType=ATTACK Entity\|TAG_CHANGE\ Entity=GameEntity\ tag=STEP\ value=MAIN_END\|TAG_CHANGE\ Entity=brbcoffee\ tag=PLAYSTATE\ value=" >>  ~/github/scratch_scripts/python/hearthstone/parsed_logs/"parsed_log.$(date +%F_%R)" &
            echo `pgrep -f "Zone.log"`
            echo "Log $(date +%F_%R) is rollin'!"
          fi
        echo "$line" | grep "FINAL_WRAPUP"
        if [ $? = 0 ]
          then
            echo "Game Over - killing above tail"
            for i in `pgrep -f "Zone.log"`; do kill $i; done
        fi
    done
