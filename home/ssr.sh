#!/bin/sh

# install shadowsocks
export SSPASSWORD=123456
docker pull shadowsocks/shadowsocks-libev
docker run -d --restart=always -p 8388:8388 -p 8388:8388/udp shadowsocks/shadowsocks-libev ss-server -p 8388  -k $SSPASSWORD -m aes-256-gcm


# install frp
mkdir /etc/frp
export TIMESTAMP=`date +%s`

# create file: frp clien config
cat>~/frpc.ini<<EOF
[common]
server_addr = 14.153.190.230
server_port = 7000
[tcp$TIMESTAMP]
type = tcp
remote_port = 8388
local_ip = 127.0.0.1
local_port = 8388
use_compression = true
group = ssr
group_key = 123
EOF

# wait shadowsocks up: start frpc
docker pull snowdreamtech/frpc:0.50.0
sleep 3s

docker run --restart=always --network host -d -v ~/frpc.ini:/etc/frp/frpc.ini --name frpc snowdreamtech/frpc:0.50.0

# complete
echo "completed!"
