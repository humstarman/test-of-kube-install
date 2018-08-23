#!/bin/bash
ansible vagrant -m script -a "/home/vagrant-y/vagrant-destroy.sh"
ansible vagrant -m script -a "/home/vagrant-y/vagrant-up.sh"
