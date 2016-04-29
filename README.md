docker-cloudera-quickstart
==========================

Docker Cloudera Quick Start Image

Cloudera Hadoop 5 (CDH5)


Now you can run the Cloudera Quick Start image without all the overhead of a Virtual Machine. Just use docker-cloudera-quickstart Image.


Based on Ubuntu 14.04 (Trusty LTS) 

Works with Cloudera CDH 5

*UPDATED FOR LATEST VERSION - CDH5.3.2


*Under development. 


#Instructions

##Install
To install the docker-cloudera-quickstart from docker-hub, simply use the following command:
```
docker pull gerencio/docker-cloudera-quickstart
```
##Use
To start an instance in BACKGROUND (as daemon):
```
docker run -i -t -d gerencio/docker-cloudera-quickstart
```
To start an instance in FOREGROUND:
```
docker run -i -t gerencio/docker-cloudera-quickstart
```
To open more terminal instances for the running instance:
```
docker ps
docker exec -i -t CONTAINER_ID bash -l
```

#Links

[Pull the image on Docker Hub](https://registry.hub.docker.com/u/gerencio/docker-cloudera-quickstart/)

[Github page](https://github.com/gerencio/docker-cloudera-quickstart)


# Checklist of components:

Apache Hadoop (Common, HDFS, MapReduce, YARN)

Apache HBase

Apache ZooKeeper

Apache Oozie

Apache Hive

Hue (Apache licensed)

Apache Flume

Cloudera Impala (Apache licensed)

Apache Sentry

Apache Sqoop

Cloudera Search (Apache licensed)

Apache Spark

[Cloudera Documentation](http://www.cloudera.com/content/cloudera/en/documentation/core/latest/)

# Debugging In Docker

## Changing Debug Delay
If a samza job dies, its log files get deleted immediately.  To allow them to hang around
for ten minutes, add the following to /etc/hadoop/conf/yarn-site.xml :
 
	  <property>
	    <description>seconds after app finishes before app's files and logs deleted</description>
	    <name>yarn.nodemanager.delete.debug-delay-sec</name>
	    <value>600</value>
	  </property>

Then you can find the logs, e.g.: `sudo -E ./yarnlogs.bash Matcher`
#Please report any issue or feedback if possible.
