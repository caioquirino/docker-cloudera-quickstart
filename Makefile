DOCKER=docker
NAME=cloudera
ORG=chatwork
TAG=diet

.PHONY: all clean run build push

all: clean build

bash:
	docker run -it \
    --expose=1024-65535 \
    -p 2181:2181 \
    -p 8020:8020 \
    -p 8888:8888 \
    -p 11000:11000 \
    -p 11443:11443 \
    -p 9090:9090 \
    -p 8088:8088 \
    -p 19888:19888 \
    -p 9092:9092 \
    -p 8983:8983 \
    -p 16000:16000 \
    -p 16001:16001 \
    -p 42222:22 \
    -p 8042:8042 \
    -p 60010:60010 \
	chatwork/cloudera:diet /bin/bash

run:
	docker run -it \
    --expose=1024-65535 \
    -p 2181:2181 \
    -p 8020:8020 \
    -p 8888:8888 \
    -p 11000:11000 \
    -p 11443:11443 \
    -p 9090:9090 \
    -p 8088:8088 \
    -p 19888:19888 \
    -p 9092:9092 \
    -p 8983:8983 \
    -p 16000:16000 \
    -p 16001:16001 \
    -p 42222:22 \
    -p 8042:8042 \
    -p 60010:60010 \
	chatwork/cloudera:diet

build:
	$(DOCKER) build . -t $(ORG)/$(NAME):$(TAG)

push:
	$(DOCKER) push $(ORG)/$(NAME):$(TAG)

clean:
	-$(DOCKER) rmi -f $(ORG)/$(NAME):$(TAG)

dist-clean:
	-$(DOCKER) ps -aq | xargs $(DOCKER) rm -f -
	-$(DOCKER) images -aq | xargs $(DOCKER) rmi -f -
