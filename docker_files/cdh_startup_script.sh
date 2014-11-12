#!/bin/bash
echo "Start HDFS"
bash -c 'for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do sudo service $x start ; done'

echo "Start Yarn"
service hadoop-yarn-resourcemanager start
service hadoop-yarn-nodemanager start
service hadoop-mapreduce-historyserver start


echo "Start Components"
service hue start
