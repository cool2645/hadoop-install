# Hadoop Install Script

This program helps set up Hadoop cluster with Debian/Ubuntu OS.

By using this script you do not need any additonal manual operation, what you need is just providing

+ Master's Hostname & ip & root password
+ Slaves' Hostname & ip & root password

and the script will automatically help you set up the cluster.

If you use this program to set up Hadoop, a useful tool *hadoopctl* will be installed, with which you can init/start/restart the cluster conveniently.

## Installation

As root,

```Shell
cp setup.conf.example setup.conf
# Now edit setup.conf
cd ./conf
cp Slave1.conf.example Slave1.conf
# Now edit Slave1.conf, you may copy a number of config files
cd ..
chmod +x setup.sh
./setup.sh
```

## Hadoop Control

After installed, as root

```Shell
hadoopctl init
hadoopctl start
```

For more information,

`hadoopctl --help`

