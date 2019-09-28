#!/usr/bin/env bash

auth_dir=$HOME/auth
mkdir ${auth_dir} -p

docker run \
--entrypoint htpasswd \
registry:2 -Bbn root root >> ${auth_dir}/htpasswd

echo "Init registry password success!"

docker-compose -f devops_compose.yml stop
docker-compose -f devops_compose.yml up -d

echo "Docker compose up success!"

