#!/bin/bash
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install apache2 ca-certificates unzip apache2-utils libapache2-mod-php7.0 -y
service apache2 start

curl --location --remote-header-name --remote-name https://github.com/ZhafranMZ/Jarkom-Modul-2-F11-2023/raw/main/resources/abimanyu.yyy.com.zip
curl --location --remote-header-name --remote-name https://github.com/ZhafranMZ/Jarkom-Modul-2-F11-2023/raw/main/resources/parikesit.abimanyu.yyy.com.zip
curl --location --remote-header-name --remote-name https://github.com/ZhafranMZ/Jarkom-Modul-2-F11-2023/raw/main/resources/rjp.baratayuda.abimanyu.yyy.com.zip
unzip ./abimanyu.yyy.com.zip
unzip ./parikesit.abimanyu.yyy.com.zip
unzip ./rjp.baratayuda.abimanyu.yyy.com.zip

mkdir -p /var/www/
mkdir /var/www/parikesit.abimanyu.f11/secret

mv ./abimanyu.yyy.com /var/www/abimanyu.f11
mv ./parikesit.abimanyu.yyy.com /var/www/parikesit.abimanyu.f11
mv ./rjp.baratayuda.abimanyu.yyy.com /var/www/rjp.baratayuda.abimanyu.f11

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

        ErrorDocument 403 /errors/403.html
        ErrorDocument 404 /errors/404.html


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

#        <Directory \"/var/www/rjp.baratayuda.abimanyu.f11\">
#            AuthType Basic
#            AuthName \"Restricted Content\"
#            AuthUserFile /etc/apache2/.htpasswd
#            Require valid-user
#        </Directory>

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

echo "
Wayang:\$apr1\$3E9.dVgh\$xxSkNA.yJqHc5NL4KI.iz1
" /etc/apache2/.htpasswd Wayang

service apache2 restart