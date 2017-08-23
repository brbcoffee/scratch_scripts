#!/usr/bin/python

# A simple hearthstone script to take user input during games, convert to json, and stick into postgres
# It will eventually read from postgres to provide historical data during the game

import json
import os
import time

def write_to_json(data_chunk):
    with open('data.json') as feedsjson:
        feeds = json.load(feedsjson)
    with open('data.json', 'w') as feedsjson:
        entry = json.dumps(data_chunk)
        feeds.append(entry)
        json.dump(feeds, feedsjson)

data = {}


opponent_class = ""
class_list = ['rogue', 'druid', 'mage', 'paladin','priest','warrior','warlock','hunter','shaman']

with open('data.json', 'w') as f:
    json.dump([], f)

while opponent_class not in class_list:
    opponent_class = raw_input("What class is your opponent playing? ").lower()
    print "Valid classes: %s" % class_list
else:
    print "Opponent is playing: %s" % opponent_class

turn = 1;
game_on = 1;


data["oppponentClass"] = opponent_class
write_to_json(data)


while game_on != "over":
    print "Turn %s" % turn
    opponents_play = raw_input("What has your opponent played on %s? " % turn)
    data["turn"] = turn
    data["opponentsPlay"] = opponents_play

    write_to_json(data)

    if raw_input("Did the opponent complete their turn? (y/n)").lower() == "y":
        turn +=1
    
    game_on = raw_input("Type 'over' if the game ended: ").lower()

# code to put into database to come.  for now, just rename the file
timestr = time.strftime("%Y%m%d-%H%M%S")
new_filename = "data.json-" + timestr
#print new_filename
os.rename("data.json", new_filename)






