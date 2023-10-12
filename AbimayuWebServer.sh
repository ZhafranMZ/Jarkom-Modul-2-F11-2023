#!/bin/bash
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install apache2 ca-certificates unzip -y
service apache2 start

curl --location --remote-header-name --remote-name https://github.com/ZhafranMZ/Jarkom-Modul-2-F11-2023/raw/main/resources/abimanyu.yyy.com.zip
unzip ./abimanyu.yyy.com.zip

mkdir -p /var/www/

mv ./arjuna.yyy.com /var/www/abimanyu.f11