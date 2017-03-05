#!/bin/bash

source ./setup.conf

# As root
cat ./slave.host >> /etc/hosts
rm -r /usr/local/hadoop
tar -zxf ~/hadoop.master.tar.gz -C /usr/local

source ./prework.sh

mkdir /home/hadoop/.ssh
cat /root/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys
chown -R hadoop /usr/local/hadoop
chown -R hadoop /home/hadoop/.ssh

echo "I'm SLAVED!"
