#!/usr/bin/env bash

function influxdb() {
    docker run --name=influxdb \
        -d \
        --rm \
        -p 8086:8086 \
        -v /var/lib/influxdb:/var/lib/influxdb \
        -v "$(pwd)"/cnf/influxdb.conf:/etc/telegraf/influxdb.conf \
        influxdb:1.5

    # 创建用户
    # CREATE USER turan WITH PASSWORD 'turan' WITH ALL PRIVILEGES
}

function telegraf() {
     docker run -d --name=telegraf \
      --rm \
      -e HOSTNAME=wanmin \
      -v "$(pwd)"/cnf/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
      -v /tmp/:/tmp/ \
      telegraf:1.5
}

function chronograf() {
    docker run --name=chronograf \
    -d \
    --rm \
    -p 8888:8888 \
    chronograf:1.5
}
