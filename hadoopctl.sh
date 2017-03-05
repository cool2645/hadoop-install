#!/bin/bash

# As root
usage()
{
	echo "Usage: `basename $0` <action>"
	echo "Possible Actions:"
	echo -e "\tinit\tInitialize hdfs"
	echo -e "\treload\tStop and remake hdfs"
	echo -e "\tstatus\tShow Hadoop status"
	echo -e "\tstart\tStart Hadoop"
	echo -e "\tstop\tStop Hadoop"
	echo -e "\trestart\tRestart Hadoop"
}
status()
{
	check
	jps
	hdfs dfsadmin -report
}
check()
{
	if [ `whoami` != 'hadoop' ]
	then
		echo "You are running as `whoami`, is this what you want?"
	fi
}
init()
{
	check
	hdfs namenode -format
}
reload()
{
	check
	stop
	rm -rf /usr/local/hadoop/tmp
	rm -rf /usr/local/hadoop/logs/*
	init
	echo "You have to clean slaves tmp before you start"
	# unfinished
	# start
}
start()
{
	check
	start-dfs.sh
	start-yarn.sh
	mr-jobhistory-daemon.sh start historyserver
	status
}
stop()
{
	check
	stop-yarn.sh
	mr-jobhistory-daemon.sh stop historyserver
	stop-dfs.sh
	status
}
restart()
{
	check
	stop
	start
}

if [[ $1 == "init" ]]
then
	init
elif [[ $1 == "status" ]]
then
	status
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
