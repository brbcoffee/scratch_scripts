#!/usr/bin/python

#requires pip install requesocks, argparser
import argparse
import fileinput
from datetime import datetime
from pytz import timezone

# -s to indicate socks proxy, -i to specify your (required) input file
parser = argparse.ArgumentParser()
parser.add_argument('-s', dest='socks', help="flags for socks proxy. Note: proxies are hard-coded in script", action="store_true")
parser.add_argument('-i', '--input', dest='input', required=True, help="Need input file: list of providers to be checked in solr")
args = parser.parse_args()

if args.socks:
    import requesocks as requests
    #hard code your proxy here
    proxies = {
        "http": "socks5://localhost:3130",
    }
else:
    import requests
    proxies = {
    }

# our environment returns solr results in Zulu time zone
zulu = timezone('Zulu')
solr_time = datetime.now(zulu)
current_solr_date = solr_time.strftime("%Y-%m-%d")

# hard to anticipate your query here, this variable will require some interpretation
print("What is the url of your solr query? (everything before /select)");
solr_url = raw_input()

# read in your source lsit
with open(args.input) as f:
    source_list = f.readlines()

for source in source_list:
    url = '%s/select?q=source%%3A%s&sort=dateCreated+desc&rows=10&wt=python' % (solr_url.rstrip(), source.rstrip())
    r = requests.get(url, proxies=proxies)
    result = eval(r.content)
    flag = 0
    for doc in result["response"]["docs"]:
        doc_date = doc["dateCreated"].split("T", 1)[0]
        if doc_date == current_solr_date:
            flag = 1
    if flag == 1:
        print "%s has had assets ingested today." % (source.rstrip())
    else:
        print "%s has NOT had assets ingested today" % (source.rstrip())
    print "\n"
