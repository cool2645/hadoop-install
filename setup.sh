#!/bin/bash

# Get current working path
SOURCE="$0"
while [ -h "$SOURCE"  ]; do
	    DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"
		SOURCE="$(readlink "$SOURCE")"
		[[ $SOURCE != /*  ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"

# Set chmod
chmod +x sshhelper.sh hadoopctl.sh

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
echo ${hadoop_password} | sudo -S sh -c "cat ./tmp/master.host >> /etc/hosts"
echo ${hadoop_password} | sudo -S sh -c "echo '0.0.0.0 Master' >> /etc/hosts"

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
mv hadoop*.tar.gz hadoop.tar.gz
echo ${hadoop_password} | sudo -S tar -zxf ~/hadoop.tar.gz -C /usr/local
cd /usr/local
echo ${hadoop_password} | sudo -S mv ./hadoop-*/ ./hadoop
echo ${hadoop_password} | sudo -S chown -R hadoop ./hadoop

# Generate xml config
cd $DIR
cp ./lib/hdfs-site.xml ./tmp/
sed -i "s/{{SLAVE_NUM}}/$slave_count/g" `grep {{SLAVE_NUM}} -l ./tmp/hdfs-site.xml`
echo ${hadoop_password} | sudo -S cp ./lib/* /usr/local/hadoop/etc/hadoop/
echo ${hadoop_password} | sudo -S cp ./tmp/hdfs-site.xml /usr/local/hadoop/etc/hadoop/
echo ${hadoop_password} | sudo -S cp ./tmp/slaves /usr/local/hadoop/etc/hadoop/

# tar
cd $DIR
tar -zcf ./tmp/hadoop.master.tar.gz /usr/local/hadoop

# Setup slaves traversily
cd $DIR
for file in ./conf/*.conf
do
    if test -f $file
    then
        source $file
		./sshhelper.sh $slave_ip $root_password
    fi
done

# Setup hadoopctl
cd $DIR
cp ./hadoopctl.sh /usr/bin/hadoopctl
chmod +x /usr/bin/hadoopctl
