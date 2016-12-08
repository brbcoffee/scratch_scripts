#!/usr/bin/python

import sys
import re
import json
import time
from shutil import copyfile
from collections import defaultdict

debug = 0

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
    global my_turn
    my_turn = 0
    identifiedOpponent = 0
    identifiedMe = 0
    opponent_first = 0
    me_first = 0
    heroes_list = ['Anduin','Tyrande','Medi','Khad','Liad','Alleria','Garrosh','Thrall','Valeera','Uther','Malfurion','Gul\'dan','Rexxar','Jaina']
    for line in log:
        for hero in heroes_list:
            if hero in line:
                if "OPPOSING PLAY (Hero)" in line:
                    opponent_hero = hero
                    identifiedOpponent = 1
                if "FRIENDLY PLAY (Hero)" in line:
                     my_hero = hero
                     identifiedMe = 1
    print "My opponent is: %s" % opponent_hero
    print "My hero is: %s" % my_hero
    while me_first == 0 and opponent_first == 0:
        for line in log:
            if "NUM_CARDS_DRAWN_THIS_TURN value=4" in line:
                if "brbcoffee" in line:
                    opponent_first = 1
                else:
                    me_first = 1

    if opponent_first == 0:
        data['me_first'] = '1'
        my_turn = 1
        print "I went first."
    else:
        data['me_first'] = '0'
        print "My opponent went first."
    return

identifyPlayersAndOrder(log)

#determine what number turn it is and determine friendly and opposing play (on that turn)

def playAnalysis(log):
    global turn_number
    global opponents_last
    turn_number = int(0)
    game_started = int(0)
    turn_counter = int(0)
    three_done = int(0)
    for line in log:
        if "NUM_CARDS_DRAWN_THIS_TURN value=3" in line:
            if three_done == 0:
                three_done = 1
            else:
                game_started = 1
                continue
        elif game_started == 0:
            continue

        if "OPPOSING PLAY" in line and not "->" in line and my_turn == 0:
            try:
                opponents_play = re.search('name=(.+?) id=', line).group(1)
                corrected_turn = turn_number + opponent_first
                data['opponents_plays'][corrected_turn].append(opponents_play)
                opponents_last = opponents_play
            except:
                print "Error"
                data['opponents_plays'][corrected_turn].append('Error')
            print "Opponent played: %s on turn %s" % (opponents_play, corrected_turn)
        if "FRIENDLY PLAY" in line and not "->" in line and my_turn == 1:
            try:
                my_play = re.search('name=(.+?) id=', line).group(1)
                corrected_turn = turn_number + me_first
                data['my_plays'][corrected_turn].append(my_play)
            except:
#                print "Error"
                data['my_plays'][corrected_turn].append('Error')
            print "I played: %s on turn %s" % (my_play, corrected_turn)
        if "brbcoffee tag=PLAYSTATE value=WON" in line:
            win = 1
        if "brbcoffee tag=PLAYSTATE value=LOST" in line:
            win = 0

        if "NUM_CARDS_DRAWN_THIS_TURN value=1" in line and turn_counter == 0:
            turn_counter = 1
            if "brbcoffee" in line:
                my_turn = 1
            else:
                my_turn = 0
            if debug == 1:
                print "_________________"
                print "1 drawn match so it is still"
                print "turn number: %s " %turn_number
                print "turn counter and turn counter becomes: %s" %turn_counter
                print line
                print "__end_______________"
        elif "NUM_CARDS_DRAWN_THIS_TURN value=1" in line and turn_counter == 1:
            turn_counter = 0
            turn_number += 1
            if "brbcoffee" in line:
                my_turn = 1
            else:
                my_turn = 0
            if debug == 1:
                print "_________________"
                print "1 drawn match so it is now"
                print "turn number: %s " %turn_number
                print "and turn counter becomes: %s" %turn_counter
                print line
                print "__end_______________"
    return(win)    

did_i_win = playAnalysis(log)

if did_i_win == 1:
    data['i_win'] = 1
    outcome = "Win"
    print "I won!"
else:
    data['i_win'] = 0
    outcome = "Loss" 
    print "I lost!"

game_time = re.search('logs_for_processing/scrubbed_log.([^,]+)',sys.argv[1]).group(1)
destination_file = "processed_logs/" + my_hero + "_" + outcome + "_" + "vs" + "_" + opponent_hero + "_last=" + opponents_last + "_" + game_time 
try:
    copyfile(sys.argv[1], destination_file)
except:
    print "log already written"

#json_file = re.search('logs_for_processing/scrubbed_log.([^,]+)',sys.argv[1]).group(1)
print game_time
with open('json_files/json_%s.data' % game_time, 'w') as f:
     json.dump(data, f)


