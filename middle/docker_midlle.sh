#!/usr/bin/env bash

function redis() {
    docker run --name redis \
    --restart always \
    -p 6379:6379 \
    -v "$(pwd)"/cnf/redis.conf:/etc/redis/redis.conf \
    -v /var/lib/redis:/data \
    -d redis:5.0.0-alpine redis-server /etc/redis/redis.conf

    # 客户端(不能使用127.0.0.1)
    # docker run -it --rm redis:5.0.0-alpine redis-cli -h 192.168.0.243 -p 6379
}

function zookeeper() {
    docker run --name zookeeper \
    --restart always \
    -p 2181:2181 \
    -v "$(pwd)"/cnf/zoo.cfg:/conf/zoo.cfg \
    -v /var/lib/zookeeper:/data/zookeeper \
    -d zookeeper:3.4.12
}

function mysql() {
    docker run --name=mysql \
    --restart always \
    -p 3306:3306 \
    -v "$(pwd)"/cnf/my.cnf:/etc/my.cnf \
    -v "$(pwd)"/mysql-init:/docker-entrypoint-initdb.d/ \
    -v /var/lib/mysql:/var/lib/mysql \
    -d -e MYSQL_ROOT_PASSWORD=root mysql:5.7.24
}