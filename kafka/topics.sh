#!/bin/bash
if [ ! -d "./kafka-bin" ]; then
    curl http://binrepo.linecorp.com/organizations/thomas-bruggink/kafka_2.13-2.7.0.tgz -o kafka_2.13-2.7.0.tgz
    tar -xvf kafka_2.13-2.7.0.tgz
    mv kafka_2.13-2.7.0 kafka-bin
    rm kafka_2.13-2.7.0.tgz
fi
kafka-bin/bin/kafka-topics.sh --bootstrap-server localhost:9092 --list
