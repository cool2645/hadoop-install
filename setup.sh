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
apt-get install openssh-server -y
mkdir /home/hadoop/.ssh
cd /home/hadoop/.ssh/
ssh-keygen -t rsa -P '' -f /home/hadoop/.ssh/id_rsa
cat ./id_rsa.pub >> ./authorized_keys
cp ./id_rsa.pub ${DIR}/tmp
chown -R hadoop /home/hadoop/.ssh

# Generate host file and slaves
cd $DIR
slave_count=0
for file in ./conf/*.conf
do
    if test -f $file
    then
        source $file
		echo "$slave_ip $slave_name" >> ./tmp/master.host
		echo "$slave_name" >> ./tmp/slaves
		slave_count=$[ slave_count + 1 ]
    fi
done
if [[ $master_serve_as_slave == 1 ]]
then
	slave_count=$[ slave_count + 1 ]
fi
cat ./tmp/master.host >> /etc/hosts
echo '0.0.0.0 Master' >> /etc/hosts

source ./setup.conf
echo "$master_ip $master_name" > ./tmp/slave.host
echo "$master_ip Master" >> ./tmp/slave.host
if [[ $master_serve_as_slave == 1 ]]
then
	echo "$master_name" >> ./tmp/slaves
fi


# Install hadoop
cd ~
wget http://mirror.bit.edu.cn/apache/hadoop/common/stable/hadoop-2.7.3.tar.gz
mv hadoop-2.7.3.tar.gz hadoop.tar.gz
tar -zxf ~/hadoop.tar.gz -C /usr/local
cd /usr/local
mv ./hadoop-*/ ./hadoop
chown -R hadoop ./hadoop

# Generate xml config
cd $DIR
cp ./lib/hdfs-site.xml ./tmp/
sed -i "s/{{SLAVE_NUM}}/$slave_count/g" `grep {{SLAVE_NUM}} -l ./tmp/hdfs-site.xml`
cp ./lib/* /usr/local/hadoop/etc/hadoop/
cp ./tmp/hdfs-site.xml /usr/local/hadoop/etc/hadoop/
cp ./tmp/slaves /usr/local/hadoop/etc/hadoop/

# tar
cd $DIR
chown -R hadoop /usr/local/hadoop
tar -zcf ./tmp/hadoop.master.tar.gz /usr/local/hadoop

# Setup slaves traversily
cd $DIR
for file in ./conf/*.conf
do
    if test -f $file
    then
        source $file
		expect sshhelper.sh $slave_ip $root_password
    fi
done