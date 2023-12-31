# Jarkom-Modul-2-F11-2023
## Kelompok F11
## NAMA :
-	Muhammad Zhafran			(5025211100)
-	Mohamad Valdi Ananda Tauhid		(5025221238)

### Quick Start
```bash
echo 'nameserver 192.168.122.1' > /etc/resolv.conf && apt-get install ca-certificates -y && curl "https://raw.githubusercontent.com/ZhafranMZ/Jarkom-Modul-2-F11-2023/main/scripts/$(hostname).sh" > script.sh && chmod +x script.sh && bash ./script.sh
```

### SOAL
1. Yudhistira akan digunakan sebagai DNS Master, Werkudara sebagai DNS Slave, Arjuna merupakan Load Balancer yang terdiri dari beberapa Web Server yaitu Prabakusuma, Abimanyu, dan Wisanggeni. Buatlah topologi dengan pembagian sebagai berikut. Folder topologi dapat diakses pada drive berikut
2. Buatlah website utama pada node arjuna dengan akses ke arjuna.yyy.com dengan alias www.arjuna.yyy.com dengan yyy merupakan kode kelompok.
3. Dengan cara yang sama seperti soal nomor 2, buatlah website utama dengan akses ke abimanyu.yyy.com dan alias www.abimanyu.yyy.com.
4. Kemudian, karena terdapat beberapa web yang harus di-deploy, buatlah subdomain parikesit.abimanyu.yyy.com yang diatur DNS-nya di Yudhistira dan mengarah ke Abimanyu.
5. Buat juga reverse domain untuk domain utama. (Abimanyu saja yang direverse)
6. Agar dapat tetap dihubungi ketika DNS Server Yudhistira bermasalah, buat juga Werkudara sebagai DNS Slave untuk domain utama.
7. Seperti yang kita tahu karena banyak sekali informasi yang harus diterima, buatlah subdomain khusus untuk perang yaitu baratayuda.abimanyu.yyy.com dengan alias www.baratayuda.abimanyu.yyy.com yang didelegasikan dari Yudhistira ke Werkudara dengan IP menuju ke Abimanyu dalam folder Baratayuda.
8. Untuk informasi yang lebih spesifik mengenai Ranjapan Baratayuda, buatlah subdomain melalui Werkudara dengan akses rjp.baratayuda.abimanyu.yyy.com dengan alias www.rjp.baratayuda.abimanyu.yyy.com yang mengarah ke Abimanyu.
9. Arjuna merupakan suatu Load Balancer Nginx dengan tiga worker (yang juga menggunakan nginx sebagai webserver) yaitu Prabakusuma, Abimanyu, dan Wisanggeni. Lakukan deployment pada masing-masing worker.
10. Kemudian gunakan algoritma Round Robin untuk Load Balancer pada Arjuna. Gunakan server_name pada soal nomor 1. Untuk melakukan pengecekan akses alamat web tersebut kemudian pastikan worker yang digunakan untuk menangani permintaan akan berganti ganti secara acak. Untuk webserver di masing-masing worker wajib berjalan di port 8001-8003. Contoh
    - Prabakusuma:8001
    - Abimanyu:8002
    - Wisanggeni:8003
11. Selain menggunakan Nginx, lakukan konfigurasi Apache Web Server pada worker Abimanyu dengan web server www.abimanyu.yyy.com. Pertama dibutuhkan web server dengan DocumentRoot pada /var/www/abimanyu.yyy
12. Setelah itu ubahlah agar url www.abimanyu.yyy.com/index.php/home menjadi www.abimanyu.yyy.com/home.
13. Selain itu, pada subdomain www.parikesit.abimanyu.yyy.com, DocumentRoot disimpan pada /var/www/parikesit.abimanyu.yyy
14. Pada subdomain tersebut folder /public hanya dapat melakukan directory listing sedangkan pada folder /secret tidak dapat diakses (403 Forbidden).
15. Buatlah kustomisasi halaman error pada folder /error untuk mengganti error kode pada Apache. Error kode yang perlu diganti adalah 404 Not Found dan 403 Forbidden.
16. Buatlah suatu konfigurasi virtual host agar file asset www.parikesit.abimanyu.yyy.com/public/js menjadi 
www.parikesit.abimanyu.yyy.com/js 
17. Agar aman, buatlah konfigurasi agar www.rjp.baratayuda.abimanyu.yyy.com hanya dapat diakses melalui port 14000 dan 14400.
18. Untuk mengaksesnya buatlah autentikasi username berupa “Wayang” dan password “baratayudayyy” dengan yyy merupakan kode kelompok. Letakkan DocumentRoot pada /var/www/rjp.baratayuda.abimanyu.yyy.
19. Buatlah agar setiap kali mengakses IP dari Abimanyu akan secara otomatis dialihkan ke www.abimanyu.yyy.com (alias)
20. Karena website www.parikesit.abimanyu.yyy.com semakin banyak pengunjung dan banyak gambar gambar random, maka ubahlah request gambar yang memiliki substring “abimanyu” akan diarahkan menuju abimanyu.png.

### PENJELASAN
**IP Masing-masing Vertex**
|Hostname|IP|
|--------|--|
|YudhistiraDNSMaster|10.57.1.2|
|WerkudaraDNSSLave|10.57.1.3|
|PrabukusumaWebServer|10.57.2.2|
|AbimanyuWebServer|10.57.2.3|
|WisanggeniWebServer|10.57.2.4|
|ArjunaLoadBalancer|10.57.3.2|
|SadewaClient|10.57.3.3|
|NakulaClient|10.57.3.4|

### CODE
#### YudhistiraDNSMaster.sh

```bash
#!/bin/bash
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install bind9 -y

# Membuat direktori untuk DNS Zone
mkdir -p /etc/bind/arjuna
mkdir -p /etc/bind/abimanyu

# Konfigurasi DNS zone
echo "
zone \"arjuna.f11.com\" {
	type master;
  notify yes;
  also-notify { 10.57.1.3; };      # IP WerkudaraDNSSLave
  allow-transfer { 10.57.1.3; };    # IP WerkudaraDNSSLave
	file \"/etc/bind/arjuna/arjuna.f11.com\";
};

zone \"abimanyu.f11.com\" {
	type master;
  notify yes;
  also-notify { 10.57.1.3; };      # IP WerkudaraDNSSLave
  allow-transfer { 10.57.1.3; };    # IP WerkudaraDNSSLave
	file \"/etc/bind/abimanyu/abimanyu.f11.com\";
};

zone \"2.57.10.in-addr.arpa\" {
    type master;
    file \"/etc/bind/abimanyu/2.57.10.in-addr.arpa\";
};

" > /etc/bind/named.conf.local

# Konfigurasi DNS zone "arjuna.f11.com"
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
@   IN  A       10.57.3.2                  # IP ArjunaLoadBalancer
@   IN  AAAA    ::1
www IN  CNAME   arjuna.f11.com.
" > /etc/bind/arjuna/arjuna.f11.com

# Konfigurasi DNS zone "abimanyu.f11.com"
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
@           IN  A       10.57.2.3          # IP AbimanyuWebServer
@           IN  AAAA    ::1
www         IN  CNAME   abimanyu.f11.com.
parikesit   IN  CNAME   abimanyu.f11.com.
ns1         IN  A       10.57.1.3          # IP WerkudaraDNSSLave
baratayuda  IN  NS      ns1
rjp         IN  NS      ns1
www.rjp     IN  NS      ns1
" > /etc/bind/abimanyu/abimanyu.f11.com

# Konfigurasi reverse DNS
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

# Konfigurasi option DNS server
echo "
options {
        directory \"/var/cache/bind\";
        allow-query{any;};
        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};" > /etc/bind/named.conf.options

# Memulai ulang BIND9
service bind9 restart
```

**Penjelasan:**
- Pertama gunakan apt-get untuk menginstall dan mengkonfigurasi BIND9 sebagai DNS server pada YudhistiraDNSMaster.
- Lalu buat direktori `/etc/bind/arjuna` dan `/etc/bind/abimanyu` untuk menyimpan file konfigurasi DNS zone.
- Selanjutnya konfigurasi DNS zone "arjuna.f11.com", "abimanyu.f11.com" dan reverse zone "2.57.10.in-addr.arpa".
- Konfigurasi DNS zone "arjuna.f11.com" berisi informasi SOA (Start of Authority), NS (Name Server), dan alamat IP.
- Konfigurasi DNS zone "abimanyu.f11.com" mencakup informasi SOA, NS, alamat IP, alias, dan beberapa subdomain seperti "parikesit," "ns1," "baratayuda," dan "rjp."
- Konfigurasi reverse DNS zone menghubungkan alamat IP dengan nama host.
- Konfigurasi option DNS server mengizinkan pertanyaan dari semua alamat IP dan menentukan direktori penyimpanan cache DNS.
- Terakhir, BIND9 dijalankan ulang untuk menerapkan konfigurasi.

#### WerkudaraDNSSlave.sh

```bash
#!/bin/bash
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install bind9 -y

# Membuat direktori untuk DNS Zone
mkdir -p /etc/bind/arjuna
mkdir -p /etc/bind/abimanyu
mkdir -p /etc/bind/baratayuda

# Konfigurasi DNS Zone
echo "
zone \"arjuna.f11.com\" {
type slave;
masters { 10.57.1.2; };          # IP YudhistiraDNSMaster
file \"/etc/bind/arjuna/arjuna.f11.com\";
};

zone \"abimanyu.f11.com\" {
type slave;
masters { 10.57.1.2; };          # IP YudhistiraDNSMaster
file \"/etc/bind/abimanyu/abimanyu.f11.com\";
};

zone \"baratayuda.abimanyu.f11.com\" {
type master;
file \"/etc/bind/baratayuda/baratayuda.abimanyu.f11.com\";
};

" > /etc/bind/named.conf.local

# Konfigurasi option DNS server
echo "
options {
        directory \"/var/cache/bind\";
        allow-query{any;};
        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};" > /etc/bind/named.conf.options

# Konfigurasi zone "baratayuda.abimanyu.f11.com"
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
@		IN	A		

	10.57.2.3
www 	IN  CNAME   baratayuda.abimanyu.f11.com.
rjp		IN	CNAME	baratayuda.abimanyu.f11.com.
www.rjp	IN	CNAME	baratayuda.abimanyu.f11.com.
" > /etc/bind/baratayuda/baratayuda.abimanyu.f11.com

# Memulai ulang BIND9
service bind9 restart
```

**Penjelasan:**
- Install dan konfigurasi BIND9 sebagai DNS server pada WerkudaraDNSSlave.
- Buat direktori `/etc/bind/arjuna`, `/etc/bind/abimanyu`, dan `/etc/bind/baratayuda` untuk menyimpan file konfigurasi DNS zone.
- Konfigurasi DNS zone "arjuna.f11.com" dan "abimanyu.f11.com" sebagai slave.
- Konfigurasi "baratayuda.abimanyu.f11.com" sebagai master.
- Konfigurasi option DNS server mengizinkan pertanyaan dari semua alamat IP dan menentukan direktori penyimpanan cache DNS.
- Terakhir, BIND9 dijalankan ulang untuk menerapkan konfigurasi.

#### AbimanyuWebServer.sh

```bash
#!/bin/bash
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install apache2 ca-certificates unzip apache2-utils libapache2-mod-php7.0 -y
service apache2 start
service php7.0-fpm start

# Mengunduh file
curl --location --remote-header-name --remote-name https://github.com/ZhafranMZ/Jarkom-Modul-2-F11-2023/raw/main/resources/abimanyu.yyy.com.zip
curl --location --remote-header-name --remote-name https://github.com/ZhafranMZ/Jarkom-Modul-2-F11-2023/raw/main/resources/parikesit.abimanyu.yyy.com.zip
curl --location --remote-header-name --remote-name https://github.com/ZhafranMZ/Jarkom-Modul-2-F11-2023/raw/main/resources/rjp.baratayuda.abimanyu.yyy.com.zip
curl --location --remote-header-name --remote-name https://github.com/ZhafranMZ/Jarkom-Modul-2-F11-2023/raw/main/resources/arjuna.yyy.com.zip

# Mengekstrak file
unzip ./abimanyu.yyy.com.zip
unzip ./parikesit.abimanyu.yyy.com.zip
unzip ./rjp.baratayuda.abimanyu.yyy.com.zip
unzip ./arjuna.yyy.com.zip

# Membuat direktori untuk web server
mkdir -p /var/www/

# Memindahkan file ke direktori web server
mv ./abimanyu.yyy.com /var/www/abimanyu.f11
mv ./parikesit.abimanyu.yyy.com /var/www/parikesit.abimanyu.f11
mv ./rjp.baratayuda.abimanyu.yyy.com /var/www/rjp.baratayuda.abimanyu.f11
mv ./arjuna.yyy.com /var/www/arjuna.f11

mkdir /var/www/parikesit.abimanyu.f11/secret

# Konfigurasi virtual host untuk situs "abimanyu.f11.com"
echo "
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/abimanyu.f11
        ServerName abimanyu.f11.com
        ServerAlias www.abimanyu.f11.com

        Alias \"/home\" \"/var/www/abimanyu.f11/index.php/home\"

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
" > /etc/apache2/sites-available/abimanyu.f11.com.conf

# Mengaktifkan konfigurasi virtual host
a2ensite abimanyu.f11.com

# Konfigurasi virtual host untuk situs "parikesit.abimanyu.f11.com"
echo "
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/parikesit.abimanyu.f11
        ServerName parikesit.abimanyu.f11.com
        ServerAlias www.parikesit.abimanyu.f11.com

        <Directory /var/www/parikesit.abimanyu.f11/public>
            Options +Indexes
        </Directory>
        <Directory /var/www/parikesit.abimanyu.f11/secret>
            Options -Indexes
        </Directory>

        Alias \"/js\" \"/var/www/parikesit.abimanyu.f11/public/js\"

        ErrorDocument 403 /errors/403.html
        ErrorDocument 404 /errors/404.html

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
" > /etc/apache2/sites-available/parikesit.abimanyu.f11.com.conf

# Mengaktifkan konfigurasi virtual host
a2ensite parikesit.abimanyu.f11.com

# Konfigurasi virtual host untuk situs "rjp.baratayuda.abimanyu.f11.com"
echo "
<VirtualHost *:14000 *:14400>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/rjp.baratayuda.abimanyu.f11
        ServerName rjp.baratayuda.abimanyu.f11.com
        ServerAlias www.rjp.baratayuda.abimanyu.f11.com

        <Directory \"/var/www/rjp.baratayuda.abimanyu.f11\">
            AuthType Basic
            AuthName \"Private Area\"
            AuthUserFile /etc/apache2/.htpasswd
  	    Require valid-user
	</Directory>

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
" > /etc/apache2/sites-available/rjp.baratayuda.abimanyu.f11.com.conf

# Mengaktifkan konfigurasi virtual host
a2ensite rjp.baratayuda.abimanyu.f11.com


echo "
# If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default.conf

Listen 80
Listen 14000    
Listen 14400

<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
" > /etc/apache2/ports.conf

echo "baratayudaf11" | htpasswd -ci /etc/apache2/.htpasswd Wayang


echo '
server {

	listen 8002;

	root /var/www/arjuna.f11;

	index index.php index.html index.htm;
	server_name _;

	location / {
			try_files $uri $uri/ /index.php?$query_string;
	}

	# pass PHP scripts to FastCGI server
	location ~ \.php$ {
	include snippets/fastcgi-php.conf;
	fastcgi_pass unix:/run/php/php7.0-fpm.sock;
	}

location ~ /\.ht {
			deny all;
	}

	error_log /var/log/nginx/jarkom_error.log;
	access_log /var/log/nginx/jarkom_access.log;
}
' > /etc/nginx/sites-available/arjuna

echo "
<VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName www.example.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        RewriteEngine On
        RewriteCond %{REQUEST_FILENAME} .*abimanyu.*\.(jpg|png|gif|jpeg) [NC]
        RewriteRule ^(.*)$ /var/www/parikesit.abimanyu.f11/public/images/abiman$

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
        #Redirect permanent / http://www.abimanyu.f11.com
        RedirectMatch permanent ^/(.*)$ http://www.abimanyu.f11.com/\$1
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
" > /etc/apache2/sites-available/000-default.conf

ln -s /etc/nginx/sites-available/arjuna /etc/nginx/sites-enabled
rm /etc/nginx/sites-enabled/default

a2enmod rewrite
service apache2 restart
service nginx restart
```

**Penjelasan:**
- Install dan konfigurasi Apache web server.
- Unduh file dari GitHub.
- Ekstrak file yang diunduh dan pindahkan ke direktori web server.
- Membuat direktori dan mengatur konfigurasi virtual host untuk situs "abimanyu.f11.com," "parikesit.abimanyu.f11.com," dan "rjp.baratayuda.abimanyu.f11.com."
- Mengaktifkan konfigurasi virtual host dan modul PHP untuk Apache.
- Mengaktifkan situs default dan me-restart layanan Apache.
- Membuat direktori dan file untuk halaman web rjp.baratayuda.abimanyu.f11.com.

#### NakulaClient.sh dan SadewaClient.sh

```bash
#!/bin/bash
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install dnsutils lynx -y
echo "
nameserver 10.57.1.2
nameserver 10.57.1.3
" > /etc/resolv.conf
```

**Penjelasan:**
- Mengatur agar menggunakan server DNS yang sesuai.


#### ArjunaLoadBalancer.sh
```bash
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
    server_name arjuna.f11.com www.arjuna.f11.com;

    location / {
        proxy_pass http://WebServer;
    }
}
" > /etc/nginx/sites-available/lb-arjuna

ln -s /etc/nginx/sites-available/lb-arjuna /etc/nginx/sites-enabled

service nginx restart
```

**Penjelasan:**
- Install dan mengkonfigurasi Nginx sebagai Load Balancer di ArjunaLoadBalancer.
- Konfigurasi Nginx dilakukan dalam file /etc/nginx/nginx.conf.
- Di dalam konfigurasi, upstream WebsServer mendefinisikan daftar server yang akan menerima permintaan. Dalam hal ini, ada tiga server: PrabakusumaWebServer, AbimanyuWebServer, dan WisanggeniWebServer yang masing-masing berjalan pada port 8001, 8002, dan 8003.
- proxy_pass http://WebServer yang mengarahkan permintaan ke daftar server yang didefinisikan dalam upstream WebServer. Algoritma Round Robin akan digunakan secara otomatis oleh Nginx untuk mendistribusikan permintaan ke setiap server di dalam daftar dengan bergantian.

#### PrabukusumaWebServer.sh and WisanggeniWebServer.sh
```bash
#!/bin/bash
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install ca-certificates unzip nginx php php-fpm -y

service php7.0-fpm start

curl --location --remote-header-name --remote-name https://github.com/ZhafranMZ/Jarkom-Modul-2-F11-2023/raw/main/resources/arjuna.yyy.com.zip
unzip ./arjuna.yyy.com.zip

mkdir -p /var/www/
mv ./arjuna.yyy.com /var/www/arjuna.f11

echo '
server {

	listen 8001;

	root /var/www/arjuna.f11;

	index index.php index.html index.htm;
	server_name _;

	location / {
			try_files $uri $uri/ /index.php?$query_string;
	}

	# pass PHP scripts to FastCGI server
	location ~ \.php$ {
	include snippets/fastcgi-php.conf;
	fastcgi_pass unix:/run/php/php7.0-fpm.sock;
	}

location ~ /\.ht {
			deny all;
	}

	error_log /var/log/nginx/jarkom_error.log;
	access_log /var/log/nginx/jarkom_access.log;
}
' > /etc/nginx/sites-available/arjuna


ln -s /etc/nginx/sites-available/arjuna /etc/nginx/sites-enabled
rm /etc/nginx/site-enabled/default

service nginx restart
```
**Penjelasan:**
- Server nginx running di port 8001-8003
