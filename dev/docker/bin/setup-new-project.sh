#!/bin/bash

set -euo pipefail
GREEN='\033[0;32m'
CLEAR='\033[0m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'

PREFIX='++'
#printf "I ${RED}love${NC} Stack Overflow\n"
printf "${GREEN}========== WELCOME TO CLI BY SON NGUYEN ==========\n${CLEAR}"
    read -p "ServerName(base_url): " base_url
    read -p "Path project(root_dir ex:/var/www/magento/): " root_dir
    
if [ ! -f /etc/apache2/sites-available/$base_url.conf ]; then
    sudo sh -c 'echo "<VirtualHost *:80>
	ErrorLog /var/log/error.log
	ServerName      '$base_url'
      DocumentRoot '$root_dir'
      <Directory '$root_dir'>
             Options +Indexes +Includes +FollowSymLinks +MultiViews
              AllowOverride All
              Require all granted
      </Directory>
      #SSLEngine on
        #SSLCertificateFile     /home/son/Documents/ssl/test-ssl.local.crt
        #SSLCertificateKeyFile /home/son/Documents/ssl/test-ssl.local.key	
	#CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" >> /etc/apache2/sites-available/'$base_url.conf

    printf "${GREEN}$PREFIX DONE => file '$base_url.conf' was created${CLEAR}\n"
else
    printf "${YELLOW}$PREFIX WARNING => file '$base_url.conf' already existed${CLEAR}\n"
fi

if [[ ! $(cat /etc/hosts) =~ '127.0.0.1 '$base_url'' ]]; then
    sudo sh -c 'echo "127.0.0.1 '$base_url'" >> /etc/hosts'
fi
printf "${GREEN}$PREFIX DONE => Added domain '$base_url' to /etc/hosts ${CLEAR}\n"
sudo a2ensite $base_url.conf	
sudo a2enmod rewrite
sudo service apache2 restart
printf "${GREEN}========== ALL DONE! ==========\n${CLEAR}"	
printf "http://$base_url \n"
