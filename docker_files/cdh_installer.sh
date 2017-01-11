#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

set -e

install_jdk_with_apps() {
	echo "Installing JDK with Applicaitons"
	apt-get update
	apt-get upgrade -y
	apt-get install -y --no-install-recommends software-properties-common

	echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
	echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections

	add-apt-repository ppa:webupd8team/java
	apt-get update -y
	apt-get install -y --force-yes --no-install-recommends oracle-java8-set-default

	echo 'JAVA_HOME="/usr/lib/jvm/java-8-oracle"' >> /etc/environment && . /etc/environment

	apt-get install -y --no-install-recommends -q wget dialog curl sudo lsof vim axel telnet

	. /tmp/install_cloudera_repositories.sh

	apt-get update

	apt-get install -y --no-install-recommends \
	    zookeeper-server \
	    hadoop-conf-pseudo \
	    oozie oozie-client \
	    hbase hbase-thrift hbase-master hbase-regionserver \
	    hue
	#		hue-search \
	#   impala impala-server impala-state-store impala-catalog impala-shell \
	#   hadoop-kms hadoop-kms-server \
	#   hive \
	#   pig \
	#   solr-server \
	#   spark-python
	#   spark-core spark-master spark-worker spark-history-server && \

	apt-get clean

	useradd kafka -m
	echo "kafka:kafka" | chpasswd && adduser kafka sudo
	KAFKA_HOME=/home/kafka
	sudo -E -u kafka mkdir -p ${KAFKA_HOME}/Downloads
	sudo -E -u kafka wget "http://mirror.cc.columbia.edu/pub/software/apache/kafka/0.8.2.1/kafka_2.10-0.8.2.1.tgz" -O ${KAFKA_HOME}/Downloads/kafka.tgz
	sudo -E -u kafka mkdir -p ${KAFKA_HOME}/kafka
	sudo -E -u kafka tar --strip 1 -xvzf ${KAFKA_HOME}/Downloads/kafka.tgz -C ${KAFKA_HOME}/kafka
	sudo -E -u kafka rm -fr ${KAFKA_HOME}/Downloads
	sudo -E -u kafka echo "auto.create.topics.enable = true" >> ${KAFKA_HOME}/kafka/config/server.properties
	sudo -E -u kafka echo "delete.topic.enable = true" >> ${KAFKA_HOME}/kafka/config/server.properties

	echo "Installed JDK with Applicaitons"
}

configure_apps() {
	echo "Removing Max Client Connections Limit for Zookeeper"
	sed -i '/maxClientCnxns/s/=.*/=0/' /etc/zookeeper/conf/zoo.cfg

	echo "Start Zookeeper"
	service zookeeper-server init
	service zookeeper-server start
	service zookeeper-server stop

	echo "Step 1 - Format the NameNode"
	sudo -E -u hdfs hdfs namenode -format

	echo "Step 2 - Start HDFS"
	bash -c 'for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do sudo -E service $x start ; done'

	echo "Step 3 - Create the directories needed for Hadoop processes"
	/usr/lib/hadoop/libexec/init-hdfs.sh

	echo "Step 4: Verify the HDFS File Structure"
	sudo -E -u hdfs hadoop fs -ls -R /

	echo "Step 5 - Start Yarn"
	service hadoop-yarn-resourcemanager start
	service hadoop-yarn-nodemanager start
	service hadoop-mapreduce-historyserver start

	echo "Step 6 - Create User Directories"
	sudo -E -u hdfs hdfs dfs -mkdir -p /user/hadoop
	sudo -E -u hdfs hdfs dfs -chown hadoop /user/hadoop
	hadoop fs -mkdir -p /tmp
	sudo -E -u hive hdfs dfs -mkdir -p /user/hive/warehouse
	hadoop fs -chmod g+w /tmp
	sudo -E -u hive hdfs dfs -chmod g+w /user/hive/warehouse
	sudo -E -u hdfs hdfs dfs -mkdir -p /hbase
	sudo -E -u hdfs hdfs dfs -chown hbase /hbase

	# For samza logs
	mkdir /var/log/samza

	echo "Add an HDH user and include as sudoer"
	useradd hdh
	echo "hdh:hdh" | chpasswd
	usermod -a -G sudo hdh
	mkdir -p /home/hdh
	chown hdh:hdh /home/hdh

	echo "Add folder for HDH"
	sudo -E -u hdfs hdfs dfs -mkdir -p /HDH
	sudo -E -u hdfs hdfs dfs -chown hdh /HDH

	echo "export HBASE_MANAGES_ZK=true" >> /etc/hbase/conf.dist/hbase-env.sh

	# Configure Oozie
	update-alternatives --set oozie-tomcat-conf /etc/oozie/tomcat-conf.http || die
	sudo -E -u hdfs hadoop fs -chown oozie:oozie /user/oozie || die
	sudo oozie-setup sharelib create -fs hdfs://localhost -locallib /usr/lib/oozie/oozie-sharelib-yarn || die
	# Initiate Oozie Database
	oozie-setup db create -run || die

	sed -i 's/secret_key=/secret_key=_S@s+D=h;B,s$C%k#H!dMjPmEsSaJR/g' /etc/hue/conf/hue.ini

    # Removed configure for solr.
	#sudo -E -u hdfs hadoop fs -mkdir -p /solr
	#sudo -E -u hdfs hadoop fs -chown solr /solr
	#mv /etc/default/solr.docker /etc/default/solr

	service hbase-master start

    # Removed initiazation for solr.
	#solrctl init
}

install_jdk_with_apps
configure_apps
