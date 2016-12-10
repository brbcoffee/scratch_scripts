#!/bin/bash

if [ ! $# == 2 ]; then
    echo 'Usage: ./ts_stage_a_opendeploy_check <file name> <email address>'
    exit
fi


for file in $(cat $1)
do
    #echo > /var/tmp/stage_a_opendeploy_check
    file_string='/var/tmp/stage_a'$(sed 's.\/.-.g' <<< $file)
    #file_string=$(sed 's.\/.-.g' <<< $file)
    echo $file_string
   # echo > /var/tmp/stage_a_$file_string
    for i in `find /share/preview/*/NEXTGEN-A$file -type f -iname "*"`
    do
        #echo $file
        md5sum $i | awk '{ printf $1 }' >> $file_string
        #md5sum $i | awk '{ printf $1 }' >> /var/tmp/stage_a_opendeploy
        short_filename=$(sed 's/.*-A//g' <<< $i )
        #echo > /var/tmp$file-stage-a

        #echo " $short_filename" >> /var/tmp/stage_a_opendeploy
        echo " $short_filename" >> $file_string
    done


    #echo $file | mutt -s "stage opendeploy check: $file" -a /var/tmp/stage_a_opendeploy "stage-a-$2"
    echo $file | mutt -s "stage opendeploy check: $file" -a $file_string "$2"
done
