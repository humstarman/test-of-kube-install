#!/bin/bash
ansible vagrant -m shell -a "mkdir -p /home/Vm/Vm1"
VMS="/home/Vm/Vm1"
for VM in $VMS; do
ansible vagrant -m copy -a "src=./centos-7.0-x86_64.box dest=$VM"
done

for VM in $VMS; do
ansible vagrant -m copy -a "src=./Vagrantfile dest=$VM"
done

for VM in "/home/Vm/Vm1"; do
   ansible vagrant -m shell -a "sed -i '10c IP = \"192.168.100.1\"+i' $VM/Vagrantfile"
   for((i=1;i<=6;i++)); do
     ansible "192.168.100.16"$i -m shell -a "sed -i '8c i = \"'$i'\"' $VM/Vagrantfile"
   done
done

