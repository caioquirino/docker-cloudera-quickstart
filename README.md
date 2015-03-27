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
docker run -i caioquirino/docker-cloudera-quickstart
```
##Use
To use the up and running instance:
```
docker ps
docker exec -i -t CONTAINER_ID bash -l
```

#Links

Pull the image on Docker Hub: https://registry.hub.docker.com/u/caioquirino/docker-cloudera-quickstart/

Github page: https://github.com/caioquirino/docker-cloudera-quickstart


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

#Please report any issue or feedback if possible.
