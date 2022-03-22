Download [`mkcert`](https://github.com/FiloSottile/mkcert/releases)

Generage valid SSL certificate for localhost:
```bash
mkcert -install
mkcert backend.sky-premium-pwa.test
mkcert sky-premium-pwa.test
```

Move ssl keys and using vhosts examples in [./vhosts](./):
```bash
sudo mkdir -p /usr/local/share/ssl/
sudo mv backend.sky-premium-pwa.test* /usr/local/share/ssl/
sudo mv sky-premium-pwa.test* /usr/local/share/ssl/
```

If using Apache:
```bash
sudo a2enmod proxy_wstunnel
sudo a2enmod proxy_http
sudo a2enmod ssl
sudo a2enmod headers
sudo a2enmod rewrite
sudo cp dev/docker/vhosts/apache/sky-premium-pwa.test.conf /etc/apache2/sites-available
sudo a2ensite sky-premium-pwa.test.conf
sudo systemctl restart apache2.service
```

If using Nginx:
```bash
sudo cp dev/docker/vhosts/nginx/sky-premium-pwa.test /etc/nginx/sites-available
sudo ln -s /etc/nginx/sites-available/sky-premium-pwa.test /etc/nginx/sites-enabled/
sudo systemctl restart nginx.service
```

Add domain into `/etc/hosts`:
```
127.0.0.1 backend.sky-premium-pwa.test sky-premium-pwa.test
```
