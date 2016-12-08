#!/bin/bash

i=`pgrep tail`; if [ $? -eq 0 ]; then ./hs_agent_v4.sh && echo hi; fi
