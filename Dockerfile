# VERSION   0.1

FROM ubuntu:14.04
MAINTAINER Caio Quirino <caioquirino@caioquirino.com.br>

ADD docker_files/cdh_installer.sh /tmp/cdh_installer.sh
ADD docker_files/cdh_startup_script.sh /usr/bin/cdh_startup_script.sh

RUN \
    chmod +x /tmp/cdh_installer.sh && \
    chmod +x /usr/bin/cdh_startup_script.sh && \
    bash /tmp/cdh_installer.sh

# private and public mapping
EXPOSE 8020:8020
EXPOSE 8888:8888
EXPOSE 11000:11000

# private only
#EXPOSE 80

# Define default command.
#CMD ["/usr/bin/cdh_startup_script.sh && bash"]
#CMD ["bash /usr/bin/cdh_startup_script.sh && bash"]
CMD ["bash"]
