# Hadoop Setup Script

This program helps set up Hadoop for Debian/Ubuntu OS.

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

After installed, as hadoop

```Shell
hadoopctl init
hadoopctl start
```

For more information,

`hadoopctl --help`

