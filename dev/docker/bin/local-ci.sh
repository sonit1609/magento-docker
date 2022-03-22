#!/bin/bash
set -xeuo pipefail

docker-compose exec -T pwa-storefront yarn lint
docker-compose exec -T pwa-storefront yarn prettier:check
docker-compose exec -T php ./vendor/bin/phpcs -pn
docker-compose exec -T php ./vendor/bin/phpstan analyse
