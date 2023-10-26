## 9. Arjuna merupakan suatu Load Balancer Nginx dengan tiga worker yaitu Prabakusuma, Abimanyu, dan Wisanggeni. Lakukan deployment pada masing-masing worker.

Buat konfig site nginx di `/etc/nginx/sites-available/lb-arjuna` pada node arjuna

```nginx
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
```

---
## 10. Kemudian gunakan algoritma Round Robin untuk Load Balancer pada Arjuna. Gunakan server_name pada soal nomor 1. Untuk melakukan pengecekan akses alamat web tersebut kemudian pastikan worker yang digunakan untuk menangani permintaan akan berganti ganti secara acak. Untuk webserver di masing-masing worker wajib berjalan di port 8001-8003.

Buat konfig site nginx di masing masing node worker pada folder `/etc/nginx/sites-available/arjuna`
```nginx
server {

	listen PORT;

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
```
**PORT merupakan port yang akan digunakan pada worker tersebut**
|Node|PORT|
|--------|--|
|PrabukusumaWebServer|8001|
|AbimanyuWebServer|8002|
|WisanggeniWebServer|8003|



---
## 15.  Buatlah kustomisasi halaman error pada folder /error untuk mengganti error kode pada Apache. Error kode yang perlu diganti adalah 404 Not Found dan 403 Forbidden.

Sebenarnya kita kemarinsudah bisa hanya saja kita butuh menunggu untuk load website 403 dan 404 nya ketika dapat warning dari lynx yaitu dengan menambahkan line ini ke konfigurasi site parikesit.abimanyu.f11.com yaitu di `/etc/apache2/sites-available/parikesit.abimanyu.f11.com.conf`
```
        ErrorDocument 403 /error/403.html
        ErrorDocument 404 /error/404.html
```

---
## 18. Untuk mengaksesnya buatlah autentikasi username berupa “Wayang” dan password “baratayudayyy” dengan yyy merupakan kode kelompok. Letakkan DocumentRoot pada /var/www/rjp.baratayuda.abimanyu.yyy.

Tambah line ini ke konfigurasi site apache yang akan dibuka secara default yaitu `/etc/apache2/sites-available/rjp.baratayuda.abimanyu.f11.com.conf`
```
        <Directory /var/www/rjp.baratayuda.abimanyu.f11>
                AuthType Basic
                AuthName \"Private Area\"
                AuthUserFile /etc/apache2/.htpasswd
                Require valid-user
        </Directory>
```

---
## 19. Buatlah agar setiap kali mengakses IP dari Abimanyu akan secara otomatis dialihkan ke www.abimanyu.yyy.com

Tambah line ini ke konfigurasi site apache yang akan dibuka secara default yaitu `/etc/apache2/sites-available/000-default.conf`
```
        RedirectMatch permanent ^/(.*)$ http://www.abimanyu.f11.com/\$1
```

---
20.  Karena website www.parikesit.abimanyu.yyy.com semakin banyak pengunjung dan banyak gambar gambar random, maka ubahlah request gambar yang memiliki substring “abimanyu” akan diarahkan menuju abimanyu.png.

Pertama butuh membikin akun di `/etc/apache2/.htpasswd` dengan username `Wayang` dan password `baratayudaf11`
```bash
echo "baratayudaf11" | htpasswd -ci /etc/apache2/.htpasswd Wayang
```

tambah line berikut kepada konfigurasi site parikesit.abimanyu.f11.com yaitu di `/etc/apache2/sites-available/parikesit.abimanyu.f11.com.conf`
```
        RewriteEngine On
        RewriteCond %{REQUEST_FILENAME} .*abimanyu.*\.(jpg|png|gif|jpeg) [NC]
        RewriteRule ^(.*)$ /var/www/parikesit.abimanyu.f11/public/images/abiman$
```

kemudian load modul apache mod_rewrite seta reload service apache2
```bash
a2enmod rewrite
service apache2 restart
```