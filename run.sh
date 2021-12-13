#!/bin/bash
if [ ! -d ./mitmproxy ]; then
    wget https://snapshots.mitmproxy.org/7.0.4/mitmproxy-7.0.4-linux.tar.gz
    mkdir mitmproxy
    tar --directory mitmproxy/ -xvf mitmproxy-7.0.4-linux.tar.gz
    rm mitmproxy-7.0.4-linux.tar.gz
fi

mitmproxy --ssl-insecure --showhost -s writer.py --listen-host 0.0.0.0 --listen-port 8080
