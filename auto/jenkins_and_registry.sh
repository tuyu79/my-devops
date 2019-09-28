#!/usr/bin/env bash

    # jenkins

    docker run \
    --name jenkins \
    --net host \
    -u root \
    -d \
    -p 8080:8080 \
    -p 50000:50000 \
    -e JAVA_OPTS=-Duser.timezone=Asia/Shanghai \
    -v /root/.m2:/root/.m2 \
    -v /etc/localtime:/etc/localtime:ro \
    -v /var/jenkins_home:/var/jenkins_home \
    -v /var/run/docker.sock:/var/run/docker.sock \
    jenkinsci/blueocean

    echo "start jenkins success!"

    # docker registry server

    docker rm -f registry-srv

    registryUiNet="registry-ui-net"

    docker network ls | awk '{if(NR > 1)print $2}' | grep ${registryUiNet}
    if [[ $? -ne 0 ]]; then
        docker network create registry-ui-net
        echo "registry-ui-net not exist,create"
    fi

    auth_dir=$HOME/auth
    mkdir  ${auth_dir}

    docker run \
    --entrypoint htpasswd \
    registry:2 -Bbn root root >> ${auth_dir}/htpasswd

    echo "init auth[root,root] to ${auth_dir}/htpasswd}"

    docker run -d \
      -p 5000:5000 \
      --net registry-ui-net \
      --restart=on-failure \
      --name registry-srv \
      -v ~/auth:/auth \
      -v /mnt/registry:/var/lib/registry \
      -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
      -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
      -e REGISTRY_STORAGE_DELETE_ENABLED=true \
      registry:2

    echo "start registry success!"

    # docker registry ui

    docker rm -f registry-ui

    docker run -d \
    --net registry-ui-net \
    --name=registry-ui \
    -p 80:80 \
    -e REGISTRY_URL=http://registry-srv:5000 \
    -e DELETE_IMAGES=true \
    -e REGISTRY_TITLE="My registry" \
    joxit/docker-registry-ui:static

    echo "start registry ui success!"
