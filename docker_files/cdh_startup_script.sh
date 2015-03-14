#!/bin/bash
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

echo "Start Components"
service hue start

service solr-server start

nohup hiveserver2 &

bash -c 'for x in `cd /etc/init.d ; ls impala-*` ; do sudo service $x start ; done'
service hbase-master start
service hbase-thrift start

echo "Press Ctrl+P and Ctrl+Q to background this process."
echo 'Use exec command to open a new bash instance for this instance (Eg. "docker exec -i -t CONTAINER_ID bash"). Container ID can be obtained using "docker ps" command.'
echo "Start Terminal"
bash
echo "Press Ctrl+C to stop instance."
sleep infinity
