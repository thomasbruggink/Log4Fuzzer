FROM ubuntu

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

ADD ./conf/run.sh /opt/kafka/
ADD ./conf/setup-user.sh /opt/kafka/
ADD ./conf/zookeeper.properties /opt/kafka/config/

ENV PATH ${PATH}:/opt/kafka
RUN chmod a+x /opt/kafka/run.sh

WORKDIR /opt/kafka
CMD ["run.sh"]
