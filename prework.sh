#!/bin/bash

# Create user hadoop
# As root
useradd -m hadoop -s /bin/bash
passwd hadoop << EOF
${hadoop_password}
${hadoop_password}
EOF
adduser hadoop sudo

# Make tmp dir
rm -rf tmp
mkdir tmp
chown -R hadoop ./tmp

# Switch to hadoop
su - hadoop << EOF
cd ~
EOF

# Install openjdk and expect
echo ${hadoop_password} | sudo -S apt-get update -y
echo ${hadoop_password} | sudo -S apt-get dist-upgrade -y 
echo ${hadoop_password} | sudo -S apt-get upgrade -y
echo ${hadoop_password} | sudo -S apt-get install openjdk-7-jre openjdk-7-jdk expect -y
str=$(dpkg -L openjdk-7-jdk | grep '/bin/javac')
JH=${str%%/bin/javac}
FILETMP=$(cat ~/.bashrc)
echo 'export JAVA_HOME='${JH} > ~/.bashrc
echo 'export PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin' >> ~/.bashrc
echo "$FILETMP" >> ~/.bashrc
source ~/.bashrc


