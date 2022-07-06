#!/bin/sh

# 倒计时 用于控制每个组件安装后的等待时长,大概率没卵用
count_down_watch(){
WAIT_SECOND=5
expr "$1" "+" 1 &> /dev/null
if [ $? -eq 0 ];then
  WAIT_SECOND=$1
  echo "$WAIT_SECOND""秒后开始执行动作"
fi

while [ "$WAIT_SECOND" -gt 0 ]
do
   echo -ne """$WAIT_SECOND"
   (( WAIT_SECOND-- ))
   sleep 1
   #清空行
   echo -ne "\r   \r"
done
}

# install shadowsocks
export SSPASSWORD=123456
docker pull shadowsocks/shadowsocks-libev
docker run -e PASSWORD=$SSPASSWORD -p 1984:8388 -p 1984:8388/udp -m aes-256-cfb -d shadowsocks/shadowsocks-libev


# install frp
mkdir /etc/frp
# create file: frp clien config
cat>/etc/frp/frpc.ini<<EOF
[common]
server_addr = 1.12.227.99
server_port = 7000

[tcp]
type = tcp
remote_port = 1984
local_ip = 127.0.0.1
local_port = 1984
EOF

# wait shadowsocks up: start frpc
count_down_watch 3

docker run --restart=always --network host -d -v /etc/frp/frpc.ini:/etc/frp/frpc.ini --name frpc snowdreamtech/frpc

# complete
echo "completed!"
