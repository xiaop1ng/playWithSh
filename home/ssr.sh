#!/bin/sh

# install shadowsocks
export SSPASSWORD=123456
docker pull shadowsocks/shadowsocks-libev
docker run -d --restart=always -p 8388:8388 -p 8388:8388/udp shadowsocks/shadowsocks-libev ss-server -p 8388  -k $SSPASSWORD -m aes-256-gcm


# install frp
mkdir /etc/frp
export TIMESTAMP=`date +%s`
# create file: frp clien config
cat>/etc/frp/frpc.ini<<EOF
[common]
server_addr = 116.76.36.169
server_port = 7000
token = 0624eb6cbdd84a4ea270e543f53f4582

[tcp$TIMESTAMP]
type = tcp
remote_port = 8388
local_ip = 127.0.0.1
local_port = 8388
use_compression = true
group = ssr
group_key = 123
# 启用健康检查，类型为 tcp
health_check_type = tcp
# 建立连接超时时间为 3 秒
health_check_timeout_s = 3
# 连续 3 次检查失败，此 proxy 会被摘除
health_check_max_failed = 3
# 每隔 60 秒进行一次健康检查
health_check_interval_s = 60
EOF

# wait shadowsocks up: start frpc
docker pull snowdreamtech/frpc
sleep 3s

docker run --restart=always --network host -d -v /etc/frp/frpc.ini:/etc/frp/frpc.ini --name frpc snowdreamtech/frpc

# complete
echo "completed!"
