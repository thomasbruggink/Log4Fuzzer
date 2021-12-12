FROM ubuntu:18.04

RUN apt-get -y update && \
    apt-get -y upgrade  && \
    apt-get -y install wget curl software-properties-common -y

# Setup JDK
RUN wget https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u202-b08/OpenJDK8U-jdk_x64_linux_hotspot_8u202b08.tar.gz -O jdk.tar.gz && \
    tar -xvf jdk.tar.gz && \
    mv jdk8u202-b08 /opt/jdk && \
    rm jdk.tar.gz
ENV JAVA_HOME=/opt/jdk
ENV PATH=${JAVA_HOME}/bin:${PATH}

RUN wget https://dlcdn.apache.org/kafka/3.0.0/kafka_2.13-3.0.0.tgz -O /opt/kafka.tgz && \
    tar -xvf /opt/kafka.tgz -C /opt && \
    mv /opt/kafka_2.13-3.0.0 /opt/kafka && \
    rm /opt/kafka.tgz && \
    mkdir /opt/logs

ENV PATH ${PATH}:/opt/kafka

# Memory heap config for Java. Default settings used by Kafka are 1G/1G (see bin/kafka-server-start.sh), but after experiencing outofmemory exceptions, this setting now changes that.
ENV KAFKA_HEAP_OPTS "-Xms1G -Xmx3G"

WORKDIR /opt/kafka

RUN apt-get update && apt-get install apt-transport-https -y
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list | tee /etc/apt/sources.list.d/microsoft.list

RUN apt-get update
RUN apt-get install -y powershell

ADD ./content/CreateTopics.ps1 /opt/kafka/bin

WORKDIR /opt/kafka/bin
CMD pwsh ./CreateTopics.ps1
