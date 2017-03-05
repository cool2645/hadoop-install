#!/bin/bash

# Get current working path
SOURCE="$0"
while [ -h "$SOURCE"  ]; do
	    DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"
		SOURCE="$(readlink "$SOURCE")"
		[[ $SOURCE != /*  ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"

# Load main conf
cd $DIR
source ./setup.conf

# Create user hadoop && Switch to hadoop
cd $DIR
source ./prework.sh

# Config ssh
echo ${hadoop_password} | sudo -S apt-get install openssh-server -y
mkdir ~/.ssh
cd ~/.ssh/
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ./id_rsa.pub >> ./authorized_keys
cp ./id_rsa.pub ${DIR}/tmp

# Generate host file
cd $DIR
slave_count=0
for file in ./conf/*.conf
do
    if test -f $file
    then
        source $file
		echo "$slave_ip $slave_name" >> ./tmp/master.host
		slave_count=$[ slave_count + 1 ]
    fi
done
source ./setup.conf
echo "$master_ip $master_name" > ./tmp/slave.host

# Install hadoop
cd ~
wget http://mirror.bit.edu.cn/apache/hadoop/common/stable/hadoop-2.7.3.tar.gz
mv hadoop*.tar.gz hadoop.tar.gz
echo ${hadoop_password} | sudo -S tar -zxf ~/hadoop.tar.gz -C /usr/local
cd /usr/local
echo ${hadoop_password} | sudo -S mv ./hadoop-*/ ./hadoop
echo ${hadoop_password} | sudo -S chown -R hadoop ./hadoop

# Generate xml config
cd $DIR
cp ./lib/hdfs-site.xml ./tmp/
sed -i "s/{{SLAVE_NUM}}/$slave_count/g" `grep {{SLAVE_NUM}} -l ./tmp/hdfs-site.xml`
cp ./tmp/* /usr/local/hadoop/etc/hadoop/
cp ./tmp/hdfs-site.xml /usr/local/hadoop/etc/hadoop/

# tar
cd $DIR
tar -zcf ./tmp/hadoop.master.tar.gz /usr/local/hadoop
