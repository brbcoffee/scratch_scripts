#!/usr/bin/env python

import requests
from pprint import pprint

if __name__ == "__main__":
    website = raw_input("Which website should we check?\n")
    if "google" in website:
        host = website
        payload = {
            "key1": "val1",
            "key2": "val2",
        }
        r = requests.get(url=host, params=payload)
        print r.url
        print pprint(vars(r))
    else:
        print "not google!"