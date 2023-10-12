#!/bin/bash
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install bind9 -y

mkdir -p /etc/bind/arjuna
mkdir -p /etc/bind/abimanyu

echo "
zone \"arjuna.f11.com\" {
	type master;
	file \"/etc/bind/arjuna/arjuna.f11.com\";
};

zone \"abimanyu.f11.com\" {
	type master;
	file \"/etc/bind/abimanyu/abimanyu.f11.com\";
};

zone \"3.57.10.in-addr.arpa\" {
    type master;
    file \"/etc/bind/arjuna/3.57.10.in-addr.arpa\";
};

zone \"2.57.10.in-addr.arpa\" {
    type master;
    file \"/etc/bind/abimanyu/2.57.10.in-addr.arpa\";
};

" > /etc/bind/named.conf.local

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
www IN  CNAME   arjuna.f11.com.
" > /etc/bind/arjuna/arjuna.f11.com

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
www         IN  CNAME   abimanyu.f11.com.
parikesit   IN  CNAME   abimanyu.f11.com.
" > /etc/bind/abimanyu/abimanyu.f11.com

echo "
\$TTL 604800
@                       IN  SOA     arjuna.f11.com. root.arjuna.f11.com. (
2023100901
604800
86400
2419200
604800
)
3.57.10.in-addr.arpa.   IN  NS  arjuna.f11.com.
2                       IN  PTR arjuna.f11.com.
" > /etc/bind/arjuna/3.57.10.in-addr.arpa

echo "
\$TTL 604800
@           IN  SOA     abimanyu.f11.com. root.abimanyu.f11.com. (
2023100901
604800
86400
2419200
604800
)
2.57.10.in-addr.arpa.   IN  NS  abimanyu.f11.com.
3                       IN  PTR abimanyu.f11.com.
" > /etc/bind/abimanyu/2.57.10.in-addr.arpa