#!/bin/bash

pip install yt-dlp

cat > nginx.conf << EOF
user  root;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    client_max_body_size 1G;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
}
EOF

cat > nginx-file-server.conf << EOF
server {
    listen 8081;
    server_name localhost;
    charset utf-8;
    root /data;

    location / {
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
    }
}
EOF

docker create -p 8081:8081 -v $(pwd):/data --name file-server --restart always nginx

docker cp $(pwd)/nginx.conf file-server:/etc/nginx/nginx.conf

docker cp $(pwd)/nginx-file-server.conf file-server:/etc/nginx/conf.d/nginx-file-server.conf

docker start file-server

rm -f $(pwd)/nginx.conf $(pwd)/nginx-file-server.conf