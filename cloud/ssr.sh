#!/bin/sh
yum install -y yum-utils
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl start docker
systemctl enable docker
# install shadowsocks
export SSPASSWORD=123456
docker pull shadowsocks/shadowsocks-libev
docker run -d --restart=always -p 8388:8388 -p 8388:8388/udp shadowsocks/shadowsocks-libev ss-server -p 8388  -k $SSPASSWORD -m aes-256-gcm