# VERSION   0.1

FROM ubuntu:14.04
MAINTAINER Caio Quirino <caioquirino@caioquirino.com.br>

ADD docker_files/cdh_installer.sh /tmp/cdh_installer.sh
ADD docker_files/install_cloudera_repositories.sh /tmp/install_cloudera_repositories.sh

ADD docker_files/cdh_startup_script.sh /usr/bin/cdh_startup_script.sh
ADD docker_files/cloudera.pref /etc/apt/preferences.d/cloudera.pref
ADD docker_files/hadoop-env.sh /etc/profile.d/hadoop-env.sh
ADD docker_files/spark-env.sh /etc/profile.d/spark-env.sh
ADD docker_files/spark-defaults.conf /etc/spark/conf/spark-defaults.conf

ENV TERM xterm

#The solr config file needs to be added after installation or it fails.
ADD docker_files/solr /etc/default/solr.docker

RUN \
    chmod +x /tmp/cdh_installer.sh && \
    chmod +x /usr/bin/cdh_startup_script.sh && \
    bash /tmp/cdh_installer.sh

ADD docker_files/yarn-site.xml /etc/hadoop/conf/yarn-site.xml
ADD docker_files/hbase-site.xml /etc/hbase/conf.dist/hbase-site.xml

# private and public mapping
EXPOSE 2181:2181
EXPOSE 8020:8020
EXPOSE 8888:8888
EXPOSE 11000:11000
EXPOSE 11443:11443
EXPOSE 9090:9090
EXPOSE 8088:8088
EXPOSE 19888:19888
EXPOSE 9092:9092
EXPOSE 8983:8983
EXPOSE 16000:16000
EXPOSE 16001:16001
EXPOSE 42222:22
EXPOSE 8042:8042
EXPOSE 60010:60010

# For Spark
EXPOSE 8080:8080
EXPOSE 7077:7077

# private only
#EXPOSE 80

# Define default command.
#CMD ["/usr/bin/cdh_startup_script.sh && bash"]
#CMD ["bash /usr/bin/cdh_startup_script.sh && bash"]
CMD ["cdh_startup_script.sh"]
