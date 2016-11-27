#!/usr/bin/python

import sys
import re
import json
from collections import defaultdict

# read in log
print sys.argv[1]
with open(sys.argv[1]) as f:
    log = f.readlines()


global data
data = {}
data['opponents_plays'] = defaultdict(list)
data['my_plays'] = defaultdict(list)


#determine heros and order
def identifyPlayersAndOrder(log):
    global opponent_hero
    global my_hero
    global opponent_first
    global me_first
    identifiedOpponent = 0
    identifiedMe = 0
    opponent_first = 0
    me_first = 0
    heroes_list = ['Anduin','Tyrande','Medi','Khad','Liad','Alleria','Garrosh','Thrall','Valeera','Uther','Malfurion','Gul','Rexxar','Jaina']
    for line in log:
        for hero in heroes_list:
            if hero in line:
                if "OPPOSING PLAY (Hero)" in line:
                    opponent_hero = hero
                    identifiedOpponent = 1
                    if "player=1" in line:
                        opponent_first = 1
                if "FRIENDLY PLAY (Hero)" in line:
                     my_hero = hero
                     identifiedMe = 1
                     if "player=1" in line:
                         me_first = 1
    print "My opponent is: %s" % opponent_hero
    print "My hero is: %s" % my_hero
    if opponent_first == 0:
        data['me_first'] = '1'
        print "I went first."
    else:
        data['me_first'] = '0'
        print "My opponent went first."
    return

identifyPlayersAndOrder(log)

#determine what number turn it is and determine friendly and opposing play (on that turn)

def playAnalysis(log):
    global turn_number
    turn_number = int(1)
    game_started = int(0)
    turn_counter = int(0)
    three_done = int(0)
    for line in log:
#        if "tag=TURN value=" in line:
#            try: 
#                turn_number = int(re.search('tag=TURN value=([^,]+)', line).group(1)) / 2
#            except:
#                pass
        if "NUM_CARDS_DRAWN_THIS_TURN value=3" in line:
            if three_done == 0:
                three_done = 1
            else:
                game_started = 1
                continue
            print "A"
            print turn_number
            #if turn_number == 0:
            #    turn_counter +=1
            #print turn_counter
        elif game_started == 0:
            continue

        if "OPPOSING PLAY" in line:
            try:
#                print line
                opponents_play = re.search('name=(.+?) id=', line).group(1)
                data['opponents_plays'][turn_number].append(opponents_play)
            except:
                print "Error"
                data['opponents_plays'][turn_number].append('Error')
            print "Opponent played: %s on turn %s" % (opponents_play, turn_number)
        if "FRIENDLY PLAY" in line:
            try:
#                print line
                my_play = re.search('name=(.+?) id=', line).group(1)
                data['my_plays'][turn_number].append(my_play)
            except:
                print "Error"
                data['my_plays'][turn_number].append('Error')
            print "I played: %s on turn %s" % (my_play, turn_number)
        if "brbcoffee tag=PLAYSTATE value=WON" in line:
            win = 1
        if "brbcoffee tag=PLAYSTATE value=LOST" in line:
            win = 0

        if "NUM_CARDS_DRAWN_THIS_TURN value=1" in line and turn_counter == 0:
            print "B"
            print turn_number
            print turn_counter
            turn_counter = 1
        elif "NUM_CARDS_DRAWN_THIS_TURN value=1" in line and turn_counter == 1:
            print "C"
            print turn_number
            print turn_counter
            turn_counter = 0
            turn_number += 1
    return(win)    

did_i_win = playAnalysis(log)

if did_i_win == 1:
    data['i_win'] = 1
    print "I won!"
else:
    data['i_win'] = 0 
    print "I lost!"

json_file = re.search('logs_for_processing/scrubbed_log.([^,]+)',sys.argv[1]).group(1)
print json_file
with open('json_%s.data' % json_file, 'w') as f:
     json.dump(data, f)







