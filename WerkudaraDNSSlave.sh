#!/bin/bash
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install bind9 -y

mkdir -p /etc/bind/arjuna
mkdir -p /etc/bind/abimanyu
mkdir -p /etc/bind/baratayuda

echo "
zone \"arjuna.f11.com\" {
type slave;
masters { 10.57.1.2; };
file \"/etc/bind/arjuna/arjuna.f11.com\";
};

zone \"abimanyu.f11.com\" {
type slave;
masters { 10.57.1.2; };
file \"/etc/bind/abimanyu/abimanyu.f11.com\";
};

zone \"baratayuda.abimanyu.f11.com\" {
type master;
file \"/etc/bind/baratayuda/baratayuda.abimanyu.f11.com\";
};

" > /etc/bind/named.conf.local

echo "
options {
        directory \"/var/cache/bind\";

        // If there is a firewall between you and nameservers you want
        // to talk to, you may need to fix the firewall to allow multiple
        // ports to talk.  See http://www.kb.cert.org/vuls/id/800113

        // If your ISP provided one or more IP addresses for stable
        // nameservers, you probably want to use them as forwarders.
        // Uncomment the following block, and insert the addresses replacing
        // the all-0's placeholder.

        // forwarders {
        //      0.0.0.0;
        // };

        //=====================================================================$
        // If BIND logs error messages about the root key being expired,
        // the all-0's placeholder.

        // forwarders {
        //      0.0.0.0;
        // };

        //=====================================================================$
        // If BIND logs error messages about the root key being expired,
        // you will need to update your keys.  See https://www.isc.org/bind-keys
        //=====================================================================$
        //dnssec-validation auto;
        allow-query{any;};

        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};" > /etc/bind/named.conf.options


echo "
\$TTL 604800
@  		IN  SOA     baratayuda.abimanyu.f11.com. root.baratayuda.abimanyu.f11.com. (
2023100901
604800
86400
2419200
604800
)
@		IN	NS		baratayuda.abimanyu.f11.com.
@		IN	A		10.57.2.3
www 	IN  CNAME   baratayuda.abimanyu.f11.com.
rjp		IN	CNAME	baratayuda.abimanyu.f11.com.
www.rjp	IN	CNAME	baratayuda.abimanyu.f11.com.
" > /etc/bind/baratayuda/baratayuda.abimanyu.f11.com
service bind9 restart