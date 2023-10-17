#!/bin/bash
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install apache2 ca-certificates unzip apache2-utils libapache2-mod-php7.0 nginx php php-fpm -y
service apache2 start
service php7.0-fpm start

curl --location --remote-header-name --remote-name https://github.com/ZhafranMZ/Jarkom-Modul-2-F11-2023/raw/main/resources/abimanyu.yyy.com.zip
curl --location --remote-header-name --remote-name https://github.com/ZhafranMZ/Jarkom-Modul-2-F11-2023/raw/main/resources/parikesit.abimanyu.yyy.com.zip
curl --location --remote-header-name --remote-name https://github.com/ZhafranMZ/Jarkom-Modul-2-F11-2023/raw/main/resources/rjp.baratayuda.abimanyu.yyy.com.zip
curl --location --remote-header-name --remote-name https://github.com/ZhafranMZ/Jarkom-Modul-2-F11-2023/raw/main/resources/arjuna.yyy.com.zip
unzip ./abimanyu.yyy.com.zip
unzip ./parikesit.abimanyu.yyy.com.zip
unzip ./rjp.baratayuda.abimanyu.yyy.com.zip
unzip ./arjuna.yyy.com.zip

mkdir -p /var/www/

mv ./abimanyu.yyy.com /var/www/abimanyu.f11
mv ./parikesit.abimanyu.yyy.com /var/www/parikesit.abimanyu.f11
mv ./rjp.baratayuda.abimanyu.yyy.com /var/www/rjp.baratayuda.abimanyu.f11
mv ./arjuna.yyy.com /var/www/arjuna.f11

mkdir -p /var/www/parikesit.abimanyu.f11/secret

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

a2ensite abimanyu.f11.com

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

        ErrorDocument 403 /error/403.html
        ErrorDocument 404 /error/404.html

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
" > /etc/apache2/sites-available/parikesit.abimanyu.f11.com.conf

a2ensite parikesit.abimanyu.f11.com

echo "
<VirtualHost *:14000 *:14400>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/rjp.baratayuda.abimanyu.f11
        ServerName rjp.baratayuda.abimanyu.f11.com
        ServerAlias www.rjp.baratayuda.abimanyu.f11.com

        <Directory /var/www/rjp.baratayuda.abimanyu.f11>
                AuthType Basic
                AuthName \"Private Area\"
                AuthUserFile /etc/apache2/.htpasswd
                Require valid-user
        </Directory>

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
" > /etc/apache2/sites-available/rjp.baratayuda.abimanyu.f11.com.conf

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

service apache2 restart

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

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
        Redirect permanent / http://www.abimanyu.f11.com
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
" > /etc/apache2/sites-available/000-default.conf

ln -s /etc/nginx/sites-available/arjuna /etc/nginx/sites-enabled
rm /etc/nginx/site-enabled/default

service nginx restart