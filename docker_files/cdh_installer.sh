#!/bin/bash
export DEBIAN_FRONTEND=noninteractive 

echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections

apt-get update
apt-get install -y --no-install-recommends software-properties-common
add-apt-repository ppa:webupd8team/java
apt-get update
apt-get install -y --no-install-recommends oracle-java7-installer oracle-java7-set-default
export JAVA_HOME=/usr/lib/jvm/java-7-oracle

apt-get install -y -q wget dialog curl sudo lsof vim axel telnet

if [ -f /tmp/install_cloudera_repositories.sh ]; then
    . /tmp/install_cloudera_repositories.sh
fi

apt-get update

apt-get -y install hadoop-conf-pseudo impala impala-server impala-state-store impala-catalog impala-shell

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
sudo -u hdfs hdfs dfs -mkdir /user/hadoop
sudo -u hdfs hdfs dfs -chown hadoop /user/hadoop
hadoop fs -mkdir       /tmp
sudo -u hive hdfs dfs -mkdir       /user/hive/warehouse
hadoop fs -chmod g+w   /tmp
sudo -u hive hdfs dfs -chmod g+w   /user/hive/warehouse
sudo -u hdfs hdfs dfs -mkdir /hbase
sudo -u hdfs hdfs dfs -chown hbase /hbase

#CDH5-Installation-Guide Install HBase
echo "Install Cloudera Components"
apt-get -y install hive hbase hbase-thrift hbase-master pig hue oozie oozie-client spark-core spark-master spark-worker spark-history-server spark-python

#Configure Oozie
update-alternatives --set oozie-tomcat-conf /etc/oozie/tomcat-conf.http
sudo -u hdfs hadoop fs -chown oozie:oozie /user/oozie
sudo oozie-setup sharelib create -fs hdfs://localhost -locallib /usr/lib/oozie/oozie-sharelib-yarn.tar.gz
#Initiate Oozie Database
oozie-setup db create -run


#Create HUE Secret Key
sed -i 's/secret_key=/secret_key=_S@s+D=h;B,s$C%k#H!dMjPmEsSaJR/g' /etc/hue/conf/hue.ini



apt-get -y install solr-server hue-search
sudo -u hdfs hadoop fs -mkdir /solr
sudo -u hdfs hadoop fs -chown solr /solr
mv /etc/default/solr.docker /etc/default/solr
service hbase-master start
solrctl init


