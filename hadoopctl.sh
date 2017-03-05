#!/bin/bash

if [[ $1 == "install" ]]
then
	source ./setup.sh
elif [[ $1 == "init" ]]
then
	echo "init!"
elif [[ $1 == "reload" ]]
then
	echo "reload!"
elif [[ $1 == "start" ]]
then
	echo "start!"
elif [[ $1 == "stop" ]]
then
	echo "stop!"
elif [[ $1 == "restart" ]]
then
	echo "restart!"
else
	echo "Usage!"
fi
