#!/usr/bin/python

import sys
import re

# read in log
print sys.argv[1]
log = open(sys.argv[1]).readlines()
#print (log.read())




def identifyPlayersAndOrder(local_file):
    identifiedOpponent = 0
    identifiedMe = 0
    opponent_first = 0
    heroes_list = ['Anduin','Garrosh','Thrall','Valeera','Uther','Malfurion','Gul','Rexxar','Jaina']
    while (identifiedOpponent == 0) or (identifiedMe == 0):
        for line in local_file:
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
        #print identifiedOpponent
    return opponent_first, opponent_hero, my_hero

def parse_name(line):
    #print "parsing"
    return line.split('=')[1][:-3]
    #return re.split(r'=', line)

def mulligan(local_file):
    first_draw = []
    mulliganed = []
    mulligan_state = 1
    while (mulligan_state == 1):
        for line in local_file:
            if "FRIENDLY HAND" in line:
                first_draw.append(parse_name(line))
            elif "FRIENDLY PLAY" in line:
                mulligan_state = 0
                break
    mulligan_state = 1
#    print first_draw
    opening_hand = []
#    print opening_hand
    #opening_hand.remove('Auchenai Soulpriest')
    #print opening_hand
#    print "\n\n"
    while (mulligan_state == 1):
        for line in local_file:
            #print line
            parsed_name = str(parse_name(line))
            if "FRIENDLY HAND" in line:
                opening_hand.append(parsed_name)
#                print "adding %s" % parsed_name
#                print opening_hand
            elif "FRIENDLY DECK" in line:
                mulliganed.append(parsed_name)
 #               print opening_hand
#                print "Remove %s" % parsed_name
 #               if parsed_name in opening_hand:
 #                   print "it's here"
                opening_hand.remove(parsed_name)
#                print opening_hand
            if "MAIN_READY" in line:
                mulligan_state = 0
                break
    return first_draw, mulliganed, opening_hand

# print identifyPlayersAndOrder(log)

mulligan_info = mulligan(log)
print "first draw: %s" % mulligan_info[0]
print "mulliganed: %s" % mulligan_info[1]
print "opening hand: %s" % mulligan_info[2]












# print "We're BACK"


