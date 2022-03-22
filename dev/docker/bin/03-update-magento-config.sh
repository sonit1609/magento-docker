#!/bin/bash
set -xe
# Update config
# Base url and https
php bin/magento config:set web/unsecure/base_url https://backend.sky-premium-pwa.test/
php bin/magento config:set web/secure/base_url https://backend.sky-premium-pwa.test/
php bin/magento config:set web/secure/use_in_frontend 1
php bin/magento config:set web/secure/use_in_adminhtml 1
php bin/magento config:set web/seo/use_rewrites 1
# Disable debug.log
yes | php bin/magento setup:config:set --enable-debug-logging=false
# Config elasticsearch
php bin/magento config:set catalog/search/engine elasticsearch7
php bin/magento config:set catalog/search/elasticsearch7_server_hostname elasticsearch
php bin/magento config:set catalog/search/elasticsearch7_index_prefix new_mweb
php bin/magento config:set catalog/search/elasticsearch7_enable_auth 0
# Flush cache
php bin/magento cache:flush
touch pwa-storefront/.docker-backend-ready
