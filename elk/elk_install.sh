#!/usr/bin/env bash

function filebeat() {
    docker run -d \
      --name=filebeat \
      --volume="$(pwd)/cnf/filebeat.yml:/usr/share/filebeat/filebeat.yml:ro" \
      --volume="/data/home/:/data/home/" \
      --volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
      docker.elastic.co/beats/filebeat:7.3.2
}

function metricbeat() {
     docker run \
     -d \
     -v "$(pwd)/cnf/metricbeat.yml:/usr/share/metricbeat/metricbeat.yml:ro" \
     --name metricbeat \
    docker.elastic.co/beats/metricbeat:7.3.2
}

function logstash() {
    docker run \
        -d \
        --name logstash \
        -v "$(pwd)/cnf/logstash.yml:/usr/share/logstash/config/logstash.yml" \
        -v "$(pwd)/cnf/pipeline/:/usr/share/logstash/pipeline/" \
        -p 5044:5044 \
        docker.elastic.co/logstash/logstash:7.3.2
}

function kibana() {
    docker run \
    -d \
    --name kibana  \
    -e "ELASTICSEARCH_HOSTS=http://172.17.0.2:9200" \
    -p 5601:5601 \
    docker.elastic.co/kibana/kibana:7.3.2
}

function elasticsearch() {
     docker run \
     -d \
     --name elasticsearch \
     -p 9200:9200 -p 9300:9300 \
     -e "discovery.type=single-node" \
     docker.elastic.co/elasticsearch/elasticsearch:7.3.2
}
