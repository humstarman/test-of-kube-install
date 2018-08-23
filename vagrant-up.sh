#!/bin/bash

CMD=$1

if [ -z "$CMD" ]; then
  CMD="vagrant up"
fi

VMS="/home/Vm/Vm1"
for VM in $VMS; do
  FILES=$(find $VM -type f -name "Vagrantfile")
  for FILE in $FILES; do
    #echo $FILE
    DIR=$(dirname $FILE)
    cd $DIR && $CMD
   done
done

