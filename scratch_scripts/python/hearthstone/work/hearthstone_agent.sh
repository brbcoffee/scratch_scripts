#/usr/bin/bash

#tail -fn0 /Applications/Hearthstone/Logs/Power.log | \
#tail -f /Users/ericyoung/github/scratch_scripts/python/hearthstone/work/test_trigger | \
#while read line ; do
#    if (echo "$line" | grep "CREATE_GAME" == 1)
#        print true

#    fi
#done

tail -fn0 /Applications/Hearthstone/Logs/Power.log | \
while read line ; do
        echo "$line" | grep "CREATE_GAME"
        if [ $? = 0 ] 
          then
            tail -f /Applications/Hearthstone/Logs/Zone.log /Applications/Hearthstone/Logs/Power.log | grep "GameState.DebugPrintPower()\ -\ TAG_CHANGE\ Entity=.*\|ZoneChangeList.ProcessChanges()\ -\ TRANSITIONING\ card\|BLOCK_START\ BlockType=ATTACK Entity\|TAG_CHANGE\ Entity=GameEntity\ tag=STEP\ value=MAIN_END\|TAG_CHANGE\ Entity=brbcoffee\ tag=PLAYSTATE\ value=" >  ~/github/scratch_scripts/python/hearthstone/parsed_logs/"parsed_log.$(date +%F_%R)" &
            #echo `ps ax | grep "[Z]one.log" | awk '{print $1}'`
            echo `pgrep -f "Zone.log"`
            #echo $pid
            echo "Log $(date +%F_%R) is rollin'!" # >> /Users/ericyoung/github/scratch_scripts/python/hearthstone/work/agent.log
          fi
        echo "$line" | grep "FINAL_WRAPUP"
        if [ $? = 0 ]
          then
            echo "Game Over - killing above tail"
            for i in `pgrep -f "Zone.log"`; do kill $i; done
        fi




#        echo "$line" | grep "FINAL_WRAPUP"
#        if [ $? = 0 ]
#          then
#            echo "game over"
#            kill `pgrep -f "Zone.log"`
#        fi
        #echo `pgrep -f "Zone.log"`
        #echo $pid
        done

#tail -fn0 /Applications/Hearthstone/Logs/Power.log | \
#while read line ; do
#        echo "hi"
#        echo "$line" | grep "CREATE_GAME"









#sub

#tail -f /Applications/Hearthstone/Logs/Zone.log /Applications/Hearthstone/Logs/Power.log | grep "GameState.DebugPrintPower()\ -\ TAG_CHANGE\ Entity=.*\|ZoneChangeList.ProcessChanges()\ -\ TRANSITIONING\ card\|BLOCK_START\ BlockType=ATTACK Entity\|TAG_CHANGE\ Entity=GameEntity\ tag=STEP\ value=MAIN_END\|TAG_CHANGE\ Entity=brbcoffee\ tag=PLAYSTATE\ value=" >  ~/github/scratch_scripts/python/hearthstone/"parsed_log.$(date +%F_%R)"
