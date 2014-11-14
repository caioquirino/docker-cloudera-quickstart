#!/bin/bash
DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y -q openjdk-7-jre-headless wget dialog curl sudo lsof vim axel

curl -s http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/archive.key | apt-key add -
echo 'deb [arch=amd64] http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh trusty-cdh5 contrib' > /etc/apt/sources.list.d/cloudera.list
echo 'deb-src http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh trusty-cdh5 contrib' >> /etc/apt/sources.list.d/cloudera.list

DEBIAN_FRONTEND=noninteractive apt-get update

DEBIAN_FRONTEND=noninteractive apt-get -y install hadoop-conf-pseudo

#CDH5-Installation-Guide Step 1 - Format the NameNode
echo "Step 1 - Format the NameNode"
sudo -u hdfs hdfs namenode -format

#CDH5-Installation-Guide Step 2 - Start HDFS
echo "Step 2 - Start HDFS"
bash -c 'for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do sudo service $x start ; done'

#CDH5-Installation-Guide Step 3 - Create the directories needed for Hadoop processes
echo "Step 3 - Create the directories needed for Hadoop processes"
/usr/lib/hadoop/libexec/init-hdfs.sh

#CDH5-Installation-Guide Step 4: Verify the HDFS File Structure
echo "Step 4: Verify the HDFS File Structure"
sudo -u hdfs hadoop fs -ls -R /

#CDH5-Installation-Guide Step 5 - Start Yarn
echo "Step 5 - Start Yarn"
service hadoop-yarn-resourcemanager start
service hadoop-yarn-nodemanager start
service hadoop-mapreduce-historyserver start

#CDH5-Installation-Guide Step 6 - Create User Directories
echo "Step 6 - Create User Directories"
sudo -u hdfs hadoop fs -mkdir /user/hadoop
sudo -u hdfs hadoop fs -chown hadoop /user/hadoop



#CDH5-Installation-Guide Install HBase
echo "Install Cloudera Components"
DEBIAN_FRONTEND=noninteractive apt-get -y install hive hbase pig hue oozie oozie-client


