#!/bin/bash

if [ -z $BROKERID ]; then
    BROKERID=0
fi

if [ -z $REPLICATIONFACTOR ]; then
    REPLICATIONFACTOR=2
fi

if [ -z $MININSYNCREPLICACOUNT ]; then
    MININSYNCREPLICACOUNT=2
fi

if [ -z $ADVERTISEADDRESS ]; then
    ADVERTISEADDRESS=$(echo `hostname -i`:9092)
fi

if [ -z $BROKERADVERTISEADDRESS ]; then
    BROKERADVERTISEADDRESS=$(echo $ADVERTISEADDRESS | cut -d ":" -f 1)
fi

if [ -z $INTERBROKERLISTENERNAME ]; then
    INTERBROKERLISTENERNAME="INTERNAL"
fi

echo "BROKERID = $BROKERID"
echo "ADVERTISEADDRESS = $ADVERTISEADDRESS"
echo "BROKERADVERTISEADDRESS = $BROKERADVERTISEADDRESS"
echo "INTERBROKERLISTENERNAME = $INTERBROKERLISTENERNAME"
echo "ZOOKEEPER = $ZOOKEEPER"
echo "REPLICATIONFACTOR = $REPLICATIONFACTOR"
echo "MININSYNCREPLICACOUNT = $MININSYNCREPLICACOUNT"

sed -i -e "s/<brokerid>/$BROKERID/" /opt/kafka/config/server.properties
sed -i -e "s/<advertisehostname>/$ADVERTISEADDRESS/" /opt/kafka/config/server.properties
sed -i -e "s/<brokeradvertisehostname>/$BROKERADVERTISEADDRESS/" /opt/kafka/config/server.properties
sed -i -e "s/<zookeeperip>/$ZOOKEEPER/" /opt/kafka/config/server.properties
sed -i -e "s/<replicationfactor>/$REPLICATIONFACTOR/" /opt/kafka/config/server.properties
sed -i -e "s/<mininsyncreplicacount>/$MININSYNCREPLICACOUNT/" /opt/kafka/config/server.properties

cat ./config/server.properties

#exec ./bin/kafka-server-start.sh ./config/server.properties &> /opt/logs/output.log
exec ./bin/kafka-server-start.sh ./config/server.properties
