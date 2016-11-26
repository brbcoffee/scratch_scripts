#!/usr/bin/python

import sys
import re
import json

# read in log
print sys.argv[1]
with open(sys.argv[1]) as f:
    log = f.readlines()

open('data.txt', 'w') as outfile:

#determine heros and order
def identifyPlayersAndOrder(log):
    global opponent_hero
    global my_hero
    global opponent_first
    global me_first
    print "ID players and order called"
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
        print "I went first."
    else:
        print "My opponent went first."
    return

identifyPlayersAndOrder(log)


#determine what number turn it is and determine friendly and opposing play (on that turn)

def playAnalysis(log):
    global turn_number
    turn_number = 0
    for line in log:
        if "tag=TURN value=" in line:
            try: 
                turn_number = int(re.search('tag=TURN value=([^,]+)', line).group(1)) / 2
            except:
                pass
        if "OPPOSING PLAY" in line and turn_number > 0:
            try:
                opponents_play = re.search('name=(.+?) id=', line).group(1)
            except:
                pass
            print "Opponent played: %s on turn %s" % (opponents_play, turn_number + opponent_first)
        if "FRIENDLY PLAY" in line and turn_number > 0:
            try:
                my_play = re.search('name=(.+?) id=', line).group(1)
            except:
                pass
            print "I played: %s on turn %s" % (my_play, turn_number + me_first)
        if "brbcoffee tag=PLAYSTATE value=WON" in line:
            did_i_win = 1
        if "brbcoffee tag=PLAYSTATE value=LOST" in line:
            did_i_win = 0
    return(did_i_win)    

did_i_win = playAnalysis(log)

if did_i_win == 1:
    print "I won!"
else:
    print "I lost!"

