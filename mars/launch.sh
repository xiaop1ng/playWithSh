#!/bin/sh

# install shadowsocks
export SSPASSWORD=123456
docker run -d -p 1984:1984 oddrationale/docker-shadowsocks -s 0.0.0.0 -p 1984 -k $SSPASSWORD -m aes-256-cfb

# install frp
cat>/etc/frp/frps.ini<<EOF
[common]
server_addr = 1.12.227.99
server_port = 7000

[tcp]
type = tcp
remote_port = 1984
local_ip = 127.0.0.1
local_port = 1984
EOF

while true
do
    if netstat -tunlp | grep 1984 | grep LISTEN | read line
    then
        echo "shadowsocks is up!"
        docker run --restart=always --network host -d -v /etc/frp/frpc.ini:/etc/frp/frpc.ini --name frpc snowdreamtech/frpc
        break
    fi
	echo "wait for shadowsocks up, 5 seconds"
	# sleep for 5 seconds
	sleep 5s
done
