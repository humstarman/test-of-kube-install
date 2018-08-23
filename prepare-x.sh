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
for HOST in $HOSTS; do
  ssh root@${EDGENODE} -t "ssh-keygen -R ${HOST}; auto-cp-ssh-id.sh root $PASSWD $HOST"
  ssh-keygen -R $HOST
  ./auto-cp-ssh-id.sh root $PASSWD $HOST
done 

scp -r $TMP/* root@${NET}1:/tmp
ssh root@${NET}1 -t "ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime"
ssh root@${NET}1 -t "echo -m ${NET}1,${NET}2,${NET}3 -n ${NET}4,${NET}5 -p $PASSWD -a vip -v ${VIP} -c calico -x ipvs -k v1.11.1 -t SCU31080T5747dd558f09b5ecab28adf0b081d80b5b7cdf2331e11 > ~/args.tmp"
ssh root@${NET}1 -t "echo -m ${NET}1,${NET}2,${NET}3 -n ${NET}4,${NET}5 -p $PASSWD -t SCU31080T5747dd558f09b5ecab28adf0b081d80b5b7cdf2331e11 > ~/args.nginx+reuse.tmp"
ssh root@${NET}1 -t "echo -m ${NET}1,${NET}2,${NET}3 -n ${NET}4,${NET}5 -p $PASSWD -r -t SCU31080T5747dd558f09b5ecab28adf0b081d80b5b7cdf2331e11 > ~/args.nginx+noreuse.tmp"
ssh root@${NET}1 -t "echo -m ${NET}1,${NET}2,${NET}3 -n ${NET}4,${NET}5 -p $PASSWD -a vip -v ${VIP} -c calico -x ipvs -k v1.11.1 -t SCU31080T5747dd558f09b5ecab28adf0b081d80b5b7cdf2331e11 > ~/args.vip+reuse.tmp"
ssh root@${NET}1 -t "echo -m ${NET}1,${NET}2,${NET}3 -n ${NET}4,${NET}5 -p $PASSWD -a vip -v ${VIP} -c calico -x ipvs -k v1.11.1 -r -t SCU31080T5747dd558f09b5ecab28adf0b081d80b5b7cdf2331e11 > ~/args.vip+noreuse.tmp"
FILE=init.sh
ssh root@${NET}1 -t "curl -O https://raw.githubusercontent.com/humstarman/ikube/master/${FILE}; chmod +x ~/${FILE}"

FILE=update-pem.sh
scp -r $TMP/cfssl* root@${NET}2:~
ssh root@${NET}2 -t "curl -O https://raw.githubusercontent.com/humstarman/ikube/master/${FILE}; chmod +x ~/${FILE}"

FILE=addons.sh
ssh root@${NET}3 -t "curl -O https://raw.githubusercontent.com/humstarman/ikube/master/${FILE}; chmod +x ~/${FILE}"
ssh root@${NET}3 -t "echo -o -l -i 192.168.100.16 -q 80 -r > ~/args.tmp"
