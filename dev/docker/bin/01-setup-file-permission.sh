#!/bin/bash
set -xe
# Setup file permissions, except folder `dev`
#find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} + \
#    && find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} + \
#    && chown -R ${HOST_UID:-1000}:www-data $(ls -a -Idev -I. -I.. -I.git)
#
## 1000 is uid of user `node` in container pwa-storefront
#find pwa-storefront -type f -exec chmod g+w {} + \
#    && find pwa-storefront -type d -exec chmod g+ws {} + \
#    && chown -R 1000:${HOST_GID:-1000} pwa-storefront
# Path: dev/docker/bin/01-setup-file-permission.sh
php bin/magento setup:upgrade
php bin/magento setup:di:compile
php bin/magento cache:flush
