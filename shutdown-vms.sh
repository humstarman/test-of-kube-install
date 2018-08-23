#!/bin/bash
CMD=${1:-"vagrant halt"}
VM_PATH="/home/Vm"
for VM in $VM_PATH; do
  FILES=$(find $VM -type f -name "Vagrantfile")
  for FILE in $FILES; do
    DIR=$(dirname $FILE)
    cd $DIR && $CMD
   done
done

