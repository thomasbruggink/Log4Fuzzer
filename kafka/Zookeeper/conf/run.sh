#!/bin/bash

if [ -z $PORT ]; then
    PORT=2181
fi

echo "PORT = $PORT"
echo "MYID = $MYID"
echo "SERVERS = $SERVERS"
ADDRESSES=$(echo $SERVERS | tr "," "\n")
for address in $ADDRESSES
do
    echo $address
done

sed -i -e "s/<port>/$PORT/" /opt/kafka/config/zookeeper.properties
serverId=1
for address in $ADDRESSES
do
    echo "server.$serverId=$address:2888:3888" >> /opt/kafka/config/zookeeper.properties
    ((serverId++))
done

cat ./config/zookeeper.properties

mkdir -p /data/zookeeper
echo $MYID > /data/zookeeper/myid

# Setup the user
./setup-user.sh &
exec ./bin/zookeeper-server-start.sh ./config/zookeeper.properties &> /opt/logs/output.log
