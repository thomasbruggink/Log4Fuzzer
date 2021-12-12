#!/bin/bash
if [ ! -d "./kafka-bin" ]; then
    curl http://binrepo.linecorp.com/organizations/thomas-bruggink/kafka_2.13-2.7.0.tgz -o kafka_2.13-2.7.0.tgz
    tar -xvf kafka_2.13-2.7.0.tgz
    mv kafka_2.13-2.7.0 kafka-bin
    rm kafka_2.13-2.7.0.tgz
fi

if [ -z $1 ]; then
    echo "First argument needs to be the topic name: ./read.sh {TOPIC}"
    exit
fi

TOPIC=$1
kafka-bin/bin/kafka-console-producer.sh --bootstrap-server localhost:9092 --topic $TOPIC
