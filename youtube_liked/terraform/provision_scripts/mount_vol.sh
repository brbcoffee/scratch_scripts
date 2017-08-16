#!/usr/bin/env bash

pvcreate /dev/xvdh
vgcreate application_data /dev/xvdh
lvcreate -l +100%FREE -n application_data_vol application_data
mkfs -t ext4 /dev/application_data/application_data_vol
mkdir /mnt/application_data
bash -c "echo '/dev/mapper/application_data-application_data_vol /mnt/application_data ext4 defaults 0 0' >> /etc/fstab"
mount /mnt/application_data
