#!/bin/bash

echo "" >> /etc/hosts
echo `docker-machine inspect default | grep "IPAddress" | awk '{gsub("[^0-9\.]", "", $2); print $2;}' | grep "\."` $1 >> /etc/hosts