#!/usr/bin/env bash

docker_rpm=./docker-ce-18.03.1.ce-1.el7.centos.x86_64.rpm

sudo yum remove docker-ce-18.03.1.ce-1.el7.centos.x86_64 -y

sudo yum install ${docker_rpm} -y

sudo systemctl start docker

sudo docker run hello-world

alias cp='cp'
cp docker-compose-Linux-x86_64 /usr/local/bin/docker-compose -f
sudo chmod +x /usr/local/bin/docker-compose
