#!/bin/bash

cd /Users/ericyoung/hs 
for i in `ls logs_for_processing/`; do ./parseLog.py logs_for_processing/$i && mv logs_for_processing/$i old/; done
