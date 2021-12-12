#!/bin/bash
#
# Copyright (c) 2021 LINE Corporation. All rights reserved.
# LINE Corporation PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
#

USER="admin"
PASS="pass"
res="-1"
while [[ $res -ne 0 ]]; do
    ./bin/kafka-configs.sh --zookeeper localhost:2181 --alter --add-config "SCRAM-SHA-512=[password=$PASS]" --entity-type users --entity-name $USER
    res=$?
    echo $res
done
echo "User '$USER' created"
