#!/bin/sh

mkdir -p /etc/hysteria && cd /etc/hysteria

# 生成证书
openssl req -newkey rsa:2048 -nodes -subj "/C=CA/ST=CA/L=CA/O=CA/OU=CA/CN=CA" -keyout key.pem -x509 -days 3650 -out certificate.pem


# install hysteria
cat>/etc/hysteria/docker-compose.yaml<<EOF
version: '3.3'
services:
  hysteria:
    image: tobyxdd/hysteria
    container_name: hysteria
    restart: always
    network_mode: "host"
    volumes:
      - ./hysteria.json:/etc/hysteria.json
      - /etc/hysteria/certificate.pem:/etc/hysteria/certificate.pem
      - /etc/hysteria/key.pem:/etc/hysteria/key.pem
    command: ["server", "--config", "/etc/hysteria.json"]
EOF

# Create your config
cat>hysteria.json<<EOF
{
  "listen": ":36712",
  "protocol": "udp",
  "cert": "/etc/hysteria/certificate.pem",
  "key": "/etc/hysteria/key.pem",
  "obfs": "mars",
  "auth": {
    "mode": "passwords",
    "config": ["123456"]
  },
  "up_mbps": 300,
  "down_mbps": 300
}
EOF

# Start container
docker-compose up -d



# install frp
mkdir /etc/frp
# create file: frp clien config
cat>/etc/frp/frpc.ini<<EOF
[common]
server_addr = 1.12.227.99
server_port = 7000

[udp1]
#!/bin/sh

mkdir -p /etc/hysteria && cd /etc/hysteria

# 生成证书
openssl req -newkey rsa:2048 -nodes -subj "/C=CA/ST=CA/L=CA/O=CA/OU=CA/CN=CA" -keyout key.pem -x509 -days 3650 -out certificate.pem


# install hysteria
cat>/etc/hysteria/docker-compose.yaml<<EOF
version: '3.3'
services:
  hysteria:
    image: tobyxdd/hysteria
    container_name: hysteria
    restart: always
    network_mode: "host"
    volumes:
      - ./hysteria.json:/etc/hysteria.json
      - /etc/hysteria/certificate.pem:/etc/hysteria/certificate.pem
      - /etc/hysteria/key.pem:/etc/hysteria/key.pem
    command: ["server", "--config", "/etc/hysteria.json"]
EOF

# Create your config
cat>hysteria.json<<EOF
{
  "listen": ":36712",
  "cert": "/etc/hysteria/certificate.pem",
  "key": "/etc/hysteria/key.pem",
  "obfs": "mars",
  "up_mbps": 300,
  "down_mbps": 300
}
EOF

# Start container
docker-compose up -d

# complete
echo "completed!"
