#!/bin/bash

url=solr-vip-as.pal.att:8080/solr/publisher/select?
#while true; do
  for i in $(cat list.txt); do
#   echo "$url$i"
    content="$(curl -s "$url$i")"
    echo "$content" >> output.txt
  done

    
