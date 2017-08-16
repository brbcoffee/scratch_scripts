#!/usr/bin/env bash

sudo pvcreate /dev/xvdh
sudo vgcreate application_data /dev/xvdh
sudo lvcreate -l +100%FREE -n application_data_vol application_data
sudo mkfs -t ext4 /dev/application_data/application_data_vol
sudo mkdir /mnt/application_data
sudo bash -c "echo '/dev/mapper/application_data-application_data_vol /mnt/application_data ext4 defaults 0 0' >> /etc/fstab"
sudo mount /mnt/application_data
sudo yum install -y git
sudo GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no -i /var/tmp/git" git clone git@github.com:brbcoffee/scratch_scripts.git /mnt/application_data/git
