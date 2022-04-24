#!/bin/sh

export SSPASSWORD=123456
docker run -d -p 1984:1984 oddrationale/docker-shadowsocks -s 0.0.0.0 -p 1984 -k $SSPASSWORD -m aes-256-cfb
cd ~
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
sudo tar xvzf ngrok-v3-stable-linux-amd64.tgz -C /usr/local/bin
ngrok config add-authtoken 28D5wL6ch4tVxNZOYmcM18GzXgq_wrg6a8Sj1RLwSYC1krhy
ngrok tcp 1984

printf "done\n";
printf "{$SSPASSWORD}\n";
printf "aes-256-cfb\n";
