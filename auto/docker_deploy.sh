#!/usr/bin/env bash

# jenkins
# 安装插件 :
# Pipeline Utility Steps
# HTTP Request Plugin
# SSH Pipeline Steps
function jenkins()
{
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
}

# 需在使用机器上的/etc/docker目录下新建daemon.json文件,放入以下内容
# { "insecure-registries":["139.9.129.68:5000"] }
# 重启docker服务 : systemctl restart docker
function registry() {

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
}

function registryUi() {

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
}

function portainer() {
    docker run \
    -d \
    -p 9000:9000 \
    --name portainer \
    --restart always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer
}

function gitlab() {
    sudo docker run --detach \
    --hostname gitlab.example.com \
    --publish 8929:80 --publish 2289:22 \
    --name gitlab \
    --restart always \
    --volume /srv/gitlab/config:/etc/gitlab \
    --volume /srv/gitlab/logs:/var/log/gitlab \
    --volume /srv/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest
}

function main() {

    container_id=$1

    case ${container_id} in
    'jenkins')
        jenkins
       ;;
    'registry')
	registry
       ;;
    'registry-ui')
	registryUi
       ;;
    esac
}

main $1
