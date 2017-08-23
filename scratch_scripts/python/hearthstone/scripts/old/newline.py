#!/usr/bin/python

import sys
import re

print sys.argv[1]
with open(sys.argv[1]) as f:
    log = f.readlines()


for line in log:
    if "to \n" in line:
        print line
