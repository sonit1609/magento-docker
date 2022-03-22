# Setup docker
## 1. Get composer access keys
Keys is in ticket: SKYDEV3-2

Create file `auth.json`:
```bash
cp auth.json.sample auth.json
```

Update file `auth.json`:
`Public Key` => `username`
`Private Key` => `password`

## 2. Start docker
Copy docker compose file:
```bash
cp docker-compose.dev.yml docker-compose.yml
```

Update value of environment variable `HOST_UID`, `HOST_GID` by value of command:
```bash
$ id -u
1000
$ id -g
1000
```
=> Update file `docker-compose.yml`:
```diff
-            HOST_UID: result of command `id -u`
+            HOST_UID: 1000
-            HOST_GID: result of command `id -g`
+            HOST_GID: 1000
```

Up and running:
```bash
docker-compose up -d
```

## 3. Custom domain
Refer to [dev/docker/vhosts/README.md](./vhosts/README.md) to setup custom domain and HTTPS:
- Magento Backend: https://backend.sky-premium-pwa.test
- PWA Storefront: https://sky-premium-pwa.test

## 4. Install Magento
Update or copy file env:
```bash
cp dev/docker/env.docker-example.php app/etc/env.php
```

**Method 1 - Fresh install:**
```bash
docker-compose exec php bash

composer install
./dev/docker/bin/01-setup-file-permission.sh
./dev/docker/bin/02-fresh-install-magento.sh
./dev/docker/bin/03-update-magento-config.sh
```

**Method 2 - Import existed database:**

After import database (through web ui: http://localhost:8088), run these commands:
```bash
docker-compose exec php bash

composer install
./dev/docker/bin/01-setup-file-permission.sh
./dev/docker/bin/03-update-magento-config.sh
```

## 5. (Dev) Disable unnecessary cron job
```bash
docker-compose exec php crontab -u magento -e
```
Comment two jobs, by adding `#` at beginning of line
```bash
#* * * * * /usr/local/bin/php /var/www/html/magento/update/cron.php >> /var/www/html/magento/var/log/update.cron.log
#* * * * * /usr/local/bin/php /var/www/html/magento/bin/magento setup:cron:run >> /var/www/html/magento/var/log/setup.cron.log
```
These two jobs is used by Magento Web Setup Wizard which we don't use in development. Disable it to reduce log to file `var/log/update.cron.log` and `var/log/setup.cron.log`.

## 6. Install Magento PWA-Studio
Copy file env for pwa storefront:
```bash
cp dev/docker/.env-pwa-storefront.example pwa-storefront/.env
```

Restart docker:
```bash
docker-compose restart pwa-storefront
```

See logs and watch the build was done:
```bash
docker-compose logs -f --tail 100 pwa-storefront
```
For example:
```bash
pwa-storefront_1  |   ┌───────────────────────────────────────────────────────────────────────────┐
pwa-storefront_1  |   │                                                                           │
pwa-storefront_1  |   │          PWADevServer ready at http://sky-premium-pwa.test:3033/          │
pwa-storefront_1  |   │   GraphQL Playground ready at http://sky-premium-pwa.test:3033/graphiql   │
pwa-storefront_1  |   │                                                                           │
pwa-storefront_1  |   └───────────────────────────────────────────────────────────────────────────┘
pwa-storefront_1  |
pwa-storefront_1  | [HPM] Proxy created: /  ->  https://backend.sky-premium-pwa.test
```

=> DONE, the web is live: https://sky-premium-pwa.test
