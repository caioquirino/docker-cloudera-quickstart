#!/bin/bash

export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_40

echo "Start Zookeeper"
service zookeeper-server start

echo "Start HDFS"
bash -c 'for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do sudo service $x start ; done'

echo "Start Yarn"
service hadoop-yarn-resourcemanager start
service hadoop-yarn-nodemanager start
chmod -R 777 /var/log/hadoop-mapreduce
service hadoop-mapreduce-historyserver start

echo "Start Oozie"
export OOZIE_URL=http://localhost:11000/oozie
service oozie start

echo "Start Spark"
service spark-master start
service spark-worker start

echo "Start Kafka"
KAFKA_HOME=/home/kafka
sudo -u kafka nohup ${KAFKA_HOME}/kafka/bin/kafka-server-start.sh ${KAFKA_HOME}/kafka/config/server.properties > ${KAFKA_HOME}/kafka/kafka.log 2>&1 &

echo "Start Components"
service hue start

service solr-server start

nohup hiveserver2 &

bash -c 'for x in `cd /etc/init.d ; ls impala-*` ; do sudo service $x start ; done'

service hbase-master start
#service hbase-regionserver start
service hbase-thrift start

echo "Start KMS"
service hadoop-kms-server start

tail -f /dev/null
