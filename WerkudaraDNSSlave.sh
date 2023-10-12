#!/bin/bash
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install bind9 -y

mkdir -p /etc/bind/arjuna
mkdir -p /etc/bind/abimanyu

echo "
zone "arjuna.f11.com" {
	type master;
	file "/etc/bind/arjuna/arjuna.f11.com";
};

zone "abimanyu.f11.com" {
	type master;
	file "/etc/bind/abimanyu/abimanyu.f11.com";
};
" >> /etc/bind/named.conf.local

echo "
\$TTL 604800
@   IN  SOA     arjuna.f11.com. root.arjuna.f11.com. (
2023100901
604800
86400
2419200
604800
)
@   IN  NS      arjuna.f11.com.
@   IN  A       10.57.3.2
@   IN  AAAA    ::1
" >> /etc/bind/arjuna/arjuna.f11.com

echo "
\$TTL 604800
@           IN  SOA     abimanyu.f11.com. root.abimanyu.f11.com. (
2023100901
604800
86400
2419200
604800
)
@           IN  NS      abimanyu.f11.com.
@           IN  A       10.57.2.3
@           IN  AAAA    ::1
" >> /etc/bind/abimanyu/abimanyu.f11.com