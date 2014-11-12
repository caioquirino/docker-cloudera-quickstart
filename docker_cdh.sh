#!/bin/bash
set -x

sudo docker rm cdh_oneclick_machine
#sudo docker rmi cdh_oneclick


set -e
sudo docker build --rm -t cdh_oneclick .
#sudo docker build --no-cache=true --rm -t cdh_oneclick .
sudo docker run --name cdh_oneclick_machine -i -t cdh_oneclick


