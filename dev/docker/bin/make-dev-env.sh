#!/bin/bash
set -euo pipefail

echo '--- 1. Setup composer access keys ---'
if [ ! -f auth.json ]; then
    cp auth.json.sample auth.json
    read -p "Composer username: " composer_username
    sed -i "s/<public-key>/$composer_username/" auth.json
    read -s -p "Composer password: " composer_password
    sed -i "s/<private-key>/$composer_password/" auth.json

    echo '+ Done => file auth.json was created'
else
    echo '+ Done => file auth.json already existed'
fi

echo '--- 2. Start docker ---'
docker_compose_cmd='docker-compose'
if [[ ! $(id -nG) =~ docker ]]; then
    docker_compose_cmd='sudo docker-compose'
fi

if [ ! -f docker-compose.yml ]; then
    cp docker-compose.dev.yml docker-compose.yml
    echo '+ docker-compose.yml was created'
else
    echo '+ docker-compose.yml already existed'
fi

sed -i "s/result of command \`id -g\`/$(id -g)/" docker-compose.yml
sed -i "s/result of command \`id -u\`/$(id -u)/" docker-compose.yml

$docker_compose_cmd up -d

echo '+ Done'

echo '--- 3. Custom domains ---'
echo '+ Install libnss3-tools, mkcert'
sudo apt-get install -y libnss3-tools
if [ ! -x "$(command -v mkcert)" ]; then
    wget -O mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-linux-amd64
    chmod +x mkcert
    sudo mv mkcert /usr/local/bin/
fi

mkcert -install
mkcert backend.sky-premium-pwa.test
mkcert sky-premium-pwa.test
sudo mkdir -p /usr/local/share/ssl/
sudo mv backend.sky-premium-pwa.test* /usr/local/share/ssl/
sudo mv sky-premium-pwa.test* /usr/local/share/ssl/

if [[ $(sudo netstat -tulpn | grep ":80 ") =~ nginx ]]; then
    echo '+ Install virtual host for nginx'
    sudo cp dev/docker/vhosts/nginx/sky-premium-pwa.test /etc/nginx/sites-available
    sudo ln -s /etc/nginx/sites-available/sky-premium-pwa.test /etc/nginx/sites-enabled/
    sudo systemctl restart nginx.service
else
    echo '+ Install virtual host for apache2'
    sudo a2enmod proxy_wstunnel
    sudo a2enmod proxy_http
    sudo a2enmod ssl
    sudo a2enmod headers
    sudo a2enmod rewrite
    sudo cp dev/docker/vhosts/apache/sky-premium-pwa.test.conf /etc/apache2/sites-available
    sudo a2ensite sky-premium-pwa.test.conf
    sudo systemctl restart apache2.service
fi

echo '+ Add domains to /etc/hosts'
if [[ ! $(cat /etc/hosts) =~ '127.0.0.1 backend.sky-premium-pwa.test sky-premium-pwa.test' ]]; then
    sudo sh -c 'echo "127.0.0.1 backend.sky-premium-pwa.test sky-premium-pwa.test" >> /etc/hosts'
fi

echo '+ Done'

echo '--- 4. Install Magento ---'
if [ ! -f app/etc/env.php ]; then
    cp dev/docker/env.docker-example.php app/etc/env.php
    echo '+ Env file app/etc/env.php was created'
else
    echo '+ Env file app/etc/env.php already existed'
fi

echo '+ Composer install'
$docker_compose_cmd exec -T php composer install
# Checkout file modified by composer
git checkout .github/PULL_REQUEST_TEMPLATE.md nginx.conf.sample

echo '+ Set file permissions'
$docker_compose_cmd exec -T php ./dev/docker/bin/01-setup-file-permission.sh

echo '+ Install magento db'
$docker_compose_cmd exec -T php ./dev/docker/bin/02-fresh-install-magento.sh

echo '+ Update magento config'
$docker_compose_cmd exec -T php ./dev/docker/bin/03-update-magento-config.sh

echo '+ Done'

echo '--- 5. Install Magento PWA-Studio ---'
if [ ! -f pwa-storefront/.env ]; then
    cp dev/docker/.env-pwa-storefront.example pwa-storefront/.env
    echo '+ Env file pwa-storefront/.env was created'
else
    echo '+ Env file pwa-storefront/.env already existed'
fi

$docker_compose_cmd restart pwa-storefront

echo '+ Done'

echo "+ To check if site is up: $docker_compose_cmd logs -f --tail 10 pwa-storefront"
echo "+ If error, restart pwa container: $docker_compose_cmd restart pwa-storefront"
