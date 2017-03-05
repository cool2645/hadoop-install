#!/bin/bash

# As root
usage()
{
	echo "Usage: `basename $0` <action>"
	echo "Possible Actions:"
	echo -e "\tinstall\tInstall Hadoop"
	echo -e "\tinit\tInitialize hdfs"
	echo -e "\treload\tStop and remake hdfs"
	echo -e "\tstart\tStart Hadoop"
	echo -e "\tstop\tStop Hadoop"
	echo -e "\trestart\tRestart Hadoop"
}
install()
{
	sh ./setup.sh
}
init()
{
	hdfs namenode -format
}
reload()
{
	stop
	rm -rf /usr/local/hadoop/tmp
	rm -rf /usr/local/hadoop/logs/*
	init
}
start()
{
	start-dfs.sh
	start-yarn.sh
	mr-jobhistory-daemon.sh start historyserver
	jps
	hdfs dfsadmin -report
}
stop()
{
	stop-yarn.sh
	mr-jobhistory-daemon.sh stop historyserver
	stop-dfs.sh
	jps
}
restart()
{
	stop
	start
}

if [[ $1 == "install" ]]
then
	install
elif [[ $1 == "init" ]]
then
	init
elif [[ $1 == "reload" ]]
then
	reload
elif [[ $1 == "start" ]]
then
	start
elif [[ $1 == "stop" ]]
then
	stop
elif [[ $1 == "restart" ]]
then
	restart
else
	usage
fi
