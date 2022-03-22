#!/bin/bash
set -xe

php bin/magento setup:upgrade
php bin/magento setup:di:compile
php bin/magento cache:flush
