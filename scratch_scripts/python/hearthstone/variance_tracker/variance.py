#!/usr/bin/python
from random import randint
import sys

#winRate = raw_input("What is the proposed win rate? ")
#numberOfGames = raw_input("Number of games played: ")

argList = sys.argv
#print argList


winRate = argList[1]
numberOfGames = argList[2]



def variance_calculate( rate, count ):
    while (count > 0):
        if (randint(0,100) < rate):
            sys.stdout.write('w')
        else:
            sys.stdout.write('l')
        count = count - 1



variance_calculate( int(winRate), int(numberOfGames) )
