#!/usr/bin/python

# A simple hearthstone script to take user input during games, convert to json, and stick into postgres
# It will eventually read from postgres to provide historical data during the game

import json
data = {}


opponent_class = ""
class_list = ['rogue', 'druid', 'mage', 'paladin','priest','warrior','warlock','hunter','shaman']

while opponent_class not in class_list:
    opponent_class = raw_input("What class is your opponent playing? ").lower()
    print "Valid classes: %s" % class_list
else:
    print "Opponent is playing: %s" % opponent_class

turn = 1;
game_on = 1;


data["oppponentClass"] = opponent_class
json_data = json.dumps(data)
print json_data
with open('data.json', 'w') as f:
    json.dump(json_data,f)

while game_on == 1:
    print "Turn %s" % turn
    opponents_play = raw_input("What has your opponent played on %s? " % turn)
    data["turn"] = turn
    data["opponentsPlay"] = opponents_play
    json_data = json.dumps(data)
    print json_data

