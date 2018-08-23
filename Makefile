SHELL=/bin/bash
NET=192.168.100
BASIC_ARG=-m 192.168.100.11,192.168.100.12,192.168.100.13 -n 192.168.100.14,192.168.100.15 -p 9ol.8ik,
MSG_ARG=-t SCU31080T5747dd558f09b5ecab28adf0b081d80b5b7cdf2331e11,SCU31117T4ea33e3f348ef4cb6ca4fd88c7ef7e805b7e0839105ab

all: build deploy run 

build:
	@./vagrant-restart.sh

deploy:
	@./prepare-x.sh

run:export ARG=-a vip -v 192.168.100.241 -c calico -x ipvs -k v1.11.1
run:export ARGS=${BASIC_ARG} ${MSG_ARG} ${ARG}
run:
	@ssh root@${NET}.11 -t "cd ~ && ./init.sh ${ARGS}"

ssh:
	@ssh root@${NET}.11

approve:
	@ssh root@${NET}.11 -t "cd ~ && ./approve-pem.sh"

test:
	@ssh root@${NET}.11 -t "kubectl get nodes"
