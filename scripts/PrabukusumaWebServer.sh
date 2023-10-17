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