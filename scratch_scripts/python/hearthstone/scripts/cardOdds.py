#!/usr/bin/python

import sys
import re
import json
import time
from shutil import copyfile
from collections import defaultdict
import random
from decimal import Decimal

debug = 0

# read in log
#print sys.argv[1]
#with open(sys.argv[1]) as f:
#    needed_cards = f.read().splitlines()

#number_of_wanted = len(needed_cards)
#fill in deck
#deck = needed_cards

number_of_keepers = int(sys.argv[1])
list_size = number_of_keepers


#while list_size < 30:
#    deck.append(list_size)
#    list_size = list_size + 1

iterations = int(sys.argv[2])
counter = 0
results = [0] * 30

print "Off coin"
while counter < iterations:
#    print "Iteration number: %s " % counter
    draw_order = random.sample(xrange(30), 30)
#    print "Original draw order:"
#    print draw_order
    #mulligan off coin
    mulligan_counter = 0
    mulligan_offset = 0
    keep_count = 0
    while mulligan_counter < 3:
        if draw_order[mulligan_counter - mulligan_offset] > number_of_keepers:
            new_position = random.randint(4,30)
#            print "New position: %s " % new_position
            draw_order.insert(new_position,draw_order.pop(mulligan_counter - mulligan_offset))
#           draw_order += [draw_order.pop(mulligan_counter - mulligan_offset)]
            mulligan_offset = mulligan_offset + 1
        mulligan_counter = mulligan_counter + 1
    counter = counter + 1
    #mulliganed order complete
    turn = 1
    cards_drawn = 4 #0,1,2,3
#    print "Post mulligan:"
#    print draw_order
    while True:
#       print draw_order[0:cards_drawn]
       if 0 in draw_order[0:cards_drawn]:
           results[turn - 1] += 1
           break
       cards_drawn += 1
       turn += 1

i = 0
value = 0
cumulative_val = 0.0
while i < len(results):
    value = results[i]/float(iterations)*100
    value = Decimal(value)
    value = round(value,2)
    cumulative_val = value + cumulative_val
    print "Turn %s percentage: %s" % (i+1,cumulative_val)
    i += 1
print results
print "Mulligan not working correctly"

