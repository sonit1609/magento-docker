# Setup docker

This guide for setting up dev env in **Ubuntu** with **apache2** or **nginx** installed.

## 1. Get composer access keys
Keys are in ticket: SKYDEV3-2

## 2. Run setup
See [MANUAL_INSTALL.md](./MANUAL_INSTALL.md) if you want to check how to install manually **OR** just run:
```bash
./dev/docker/bin/make-dev-env.sh
```

## 3. Disable unnecessary cron jobs
```bash
docker-compose exec php crontab -u magento -e
```
Comment out two jobs, by adding `#` at beginning of line
```bash
#* * * * * /usr/local/bin/php /var/www/html/magento/update/cron.php >> /var/www/html/magento/var/log/update.cron.log
#* * * * * /usr/local/bin/php /var/www/html/magento/bin/magento setup:cron:run >> /var/www/html/magento/var/log/setup.cron.log
```
These two jobs is used by Magento Web Setup Wizard which we don't use in development. Disable it to reduce log to file `var/log/update.cron.log` and `var/log/setup.cron.log`.

## 4. Restart Magento PWA-Studio
See logs and watch if build process has been done or not:
```bash
docker-compose logs -f --tail 10 pwa-storefront
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

If there are any errors, restart docker to build again:
```bash
docker-compose restart pwa-storefront
```

## Site urls
- Admin: https://backend.sky-premium-pwa.test/admin_mn (admin account is in file [dev/docker/bin/02-fresh-install-magento.sh](./bin/02-fresh-install-magento.sh))
- Front site: https://sky-premium-pwa.test/
- Database: http://127.0.0.1:8088/
- Mailbox: http://127.0.0.1:8022/

