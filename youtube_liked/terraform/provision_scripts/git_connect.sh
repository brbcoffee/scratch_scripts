#!/usr/bin/env bash

yum install -y git
GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no -i /var/tmp/git" git clone git@github.com:brbcoffee/scratch_scripts.git /mnt/application_data/git
