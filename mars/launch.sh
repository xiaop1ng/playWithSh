#!/bin/sh

# install shadowsocks
export SSPASSWORD=123456
docker run -d -p 1984:1984 oddrationale/docker-shadowsocks -s 0.0.0.0 -p 1984 -k $SSPASSWORD -m aes-256-cfb

# install frp
mkdir /etc/frp
# create file: frp clien config
cat>/etc/frp/frpc.ini<<EOF
[common]
server_addr = 1.12.227.99
server_port = 7000

[tcp1]
type = tcp
remote_port = 1984
local_ip = 127.0.0.1
local_port = 1984
EOF

# wait shadowsocks up: start frpc
docker pull snowdreamtech/frpc
sleep 3s

docker run --restart=always --network host -d -v /etc/frp/frpc.ini:/etc/frp/frpc.ini --name frpc snowdreamtech/frpc

# complete
echo "completed!"
