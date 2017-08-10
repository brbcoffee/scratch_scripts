#!/usr/bin/env python

import json
from pprint import pprint

json_data = open("blah").read()
data = json.loads(json_data)
pprint(data)