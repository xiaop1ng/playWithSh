#!/bin/sh

##
# 解析参数
##
ip= # server ip

for key in "$@"; do
  case $key in
    --ip=*)
      ip="${key#*=}"
      shift # past argument=value
      ;;
    *)
      ;;
  esac
dones

echo 'ip: '${ip}''

# install shadowsocks
export SSPASSWORD=123456
docker pull shadowsocks/shadowsocks-libev
docker run -d --restart=always -p 8388:8388 -p 8388:8388/udp shadowsocks/shadowsocks-libev ss-server -p 8388  -k $SSPASSWORD -m aes-256-gcm


# install frp
mkdir /etc/frp
# create file: frp clien config
cat>/etc/frp/frpc.ini<<EOF
[common]
server_addr = $ip
server_port = 7500

[tcp]
type = tcp
remote_port = 8388
local_ip = 127.0.0.1
local_port = 8388
EOF

# wait shadowsocks up: start frpc
docker pull snowdreamtech/frpc
sleep 3s

docker run --restart=always --network host -d -v /etc/frp/frpc.ini:/etc/frp/frpc.ini --name frpc snowdreamtech/frpc

# complete
echo "completed!"