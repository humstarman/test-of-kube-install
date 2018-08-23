#!/bin/bash

NET=192.168.100.1
TMP=/opt/app/for-test
PASSWD="9ol.8ik,"
EDGENODE=192.168.100.167
VIP=192.168.100.241
HOSTS=""
IDS="1 2 3 4 5 6"
for i in $IDS; do 
  HOSTS+=$NET
  HOSTS+=$i
  HOSTS+=" "
done 

scp -r $TMP/* root@${NET}6:/tmp
ssh root@${NET}6 -t "echo -m ${NET}6 -p $PASSWD > ~/args.tmp"
FILE=init.sh
ssh root@${NET}6 -t "curl -O https://raw.githubusercontent.com/humstarman/ikube/master/${FILE}; chmod +x ~/${FILE}"
