#!/usr/bin/env bash
sleep 10
sudo bash -c "echo '172.31.1.1 puppet' >> /etc/hosts"
name=`curl http://169.254.169.254/latest/meta-data/local-hostname`
sudo puppet agent -t
ssh -o StrictHostKeyChecking=no  -i /var/tmp/key ec2-user@puppet sudo puppet cert sign $name
sudo puppet agent -t
exit 0
