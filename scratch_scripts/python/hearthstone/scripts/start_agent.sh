#!/bin/bash

i=`pgrep tail`; if [ $? -eq 1 ]; then ./hs_agent_v4.sh; fi
