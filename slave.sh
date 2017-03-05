#!/bin/bash

source ./setup.conf

# As root
cat ./tmp/master.host >> /etc/hosts
rm -r /usr/local/hadoop
tar -zxf ~/hadoop.master.tar.gz -C /usr/local

source ./prework.sh

mkdir ~/.ssh
echo ${hadoop_password} | sudo -S sh -c "cat /home/root/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys"
echo ${hadoop_password} | sudo -S chown -R /usr/local/hadoop hadoop

echo "I'm SLAVED!"
