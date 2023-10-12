#!/bin/bash
echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install apache2 ca-certificates unzip -y
service apache2 start

curl --location --remote-header-name --remote-name https://github.com/ZhafranMZ/Jarkom-Modul-2-F11-2023/raw/main/resources/abimanyu.yyy.com.zip
curl --location --remote-header-name --remote-name https://github.com/ZhafranMZ/Jarkom-Modul-2-F11-2023/raw/main/resources/parikesit.abimanyu.yyy.com.zip
unzip ./abimanyu.yyy.com.zip
unzip ./parikesit.abimanyu.yyy.com.zip

mkdir -p /var/www/

mv ./abimanyu.yyy.com /var/www/abimanyu.f11
mv ./parikesit.abimanyu.yyy.com /var/www/parikesit.abimanyu.f11

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

echo "
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/parikesit.abimanyu.f11
        ServerName parikesit.abimanyu.f11.com
        ServerAlias www.parikesit.abimanyu.f11.com

        <Directory /var/www/parikesit.abimanyu.f11/public>
            Options +Indexes
        </Directory>
        <Directory /var/www/parikesit.abimanyu.f11/public>
            Options +Indexes
        </Directory>
        <Directory /var/www/parikesit.abimanyu.f11/secret>
            Options -Indexes
        </Directory>

        Alias \"/js\" \"/var/www/jarkom2022.com/public/js\"
        
        ErrorDocument 403 /errors/403.html
        ErrorDocument 404 /errors/404.html


        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
" > /etc/apache2/sites-available/parikesit.abimanyu.f11.com.conf

service apache2 restart