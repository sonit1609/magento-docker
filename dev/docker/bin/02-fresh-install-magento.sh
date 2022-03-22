#!/bin/bash
set -xe
bin/magento setup:install --base-url=https://backend.sky-premium-pwa.test --db-host=mysql --db-name=magento_db --db-user=son --db-password=123 --admin-firstname=admin --admin-lastname=admin --admin-email=admin@admin.com --admin-user=son --admin-password=son@123 --language=en_US --currency=USD --timezone=America/Chicago --use-rewrites=1 --elasticsearch-host=elasticsearch