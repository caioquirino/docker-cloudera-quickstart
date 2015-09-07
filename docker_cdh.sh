#!/bin/bash
set -x

docker rm -f cdh
#sudo docker rmi cdh

set -e
docker build --rm -t cdh .
#sudo docker build --no-cache=true --rm -t cdh .
# Use dockerhost as the hostname
docker run --name cdh -i -t -h dockerhost cdh


