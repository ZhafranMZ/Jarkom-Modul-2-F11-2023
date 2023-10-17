#!/bin/bash
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install nginx -y

# Konfigurasi Nginx untuk Load Balancer
echo "
upstream WebServer {
    server 10.57.2.2:8001;
    server 10.57.2.3:8002;
    server 10.57.2.4:8003;
}

server {
    listen 80;
    server_name arjuna.f11.com;

    location / {
        proxy_pass http://WebServer;
    }
}
" > /etc/nginx/sites-available/lb-arjuna

ln -s /etc/nginx/sites-available/lb-arjuna /etc/nginx/sites-enabled

service nginx restart