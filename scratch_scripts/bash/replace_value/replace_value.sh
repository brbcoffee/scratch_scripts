#!/usr/local/bin/bash

for i in $(cat $1); do
  IFS=, read  old new <<< $i
  #echo "replacing "$old "with "$new
  for i in $(ls *); do
    sed 's/$old/$new/g' $i
  done
done
