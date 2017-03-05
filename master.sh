#!/bin/bash
#
source hadoop_install.conf
# Create user hadoop
useradd -m hadoop -s /bin/bash
passwd hadoop << EOF
${hadoop_password}
${hadoop_password}
EOF
adduser hadoop sudo
su - hadoop << EOF
cd ~
EOF

# Install openjdk
echo ${hadoop_password} | sudo -S apt-get update -y
echo ${hadoop_password} | sudo -S apt-get dist-upgrade -y 
echo ${hadoop_password} | sudo -S apt-get upgrade -y
echo ${hadoop_password} | sudo -S apt-get install openjdk-7-jre openjdk-7-jdk
str=$(dpkg -L openjdk-7-jdk | grep '/bin/javac')
JH=${str%%/bin/javac}
echo 'export JAVA_HOME='$JH >> ~/.bashrc
source ~/.bashrc

# Config ssh
echo ${hadoop_password} | sudo -S apt-get install openssh-server -y
mkdir ~/.ssh
cd ~/.ssh/
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ./id_rsa.pub >> ./authorized_keys

# Install hadoop
cd ~
wget http://mirror.bit.edu.cn/apache/hadoop/common/stable/hadoop-2.7.3.tar.gz
mv hadoop*.tar.gz hadoop.tar.gz
echo ${hadoop_password} | sudo -S tar -zxf ~/hadoop.tar.gz -C /usr/local
cd /usr/local/
echo ${hadoop_password} | sudo -S mv ./hadoop-*/ ./hadoop
echo ${hadoop_password} | sudo -S chown -R hadoop ./hadoop