<?php
return [
    'backend' => [
        'frontName' => 'admin_mn',
    ],
    'db' => [
        'connection' => [
            'indexer' => [
                'host' => 'mysql',
                'dbname' => 'magento_db',
                'username' => 'magento',
                'password' => 'secret',
                'model' => 'mysql4',
                'engine' => 'innodb',
                'initStatements' => 'SET NAMES utf8;',
                'active' => '1',
                'persistent' => null,
            ],
            'default' => [
                'host' => 'mysql',
                'dbname' => 'magento_db',
                'username' => 'magento',
                'password' => 'secret',
                'model' => 'mysql4',
                'engine' => 'innodb',
                'initStatements' => 'SET NAMES utf8;',
                'active' => '1',
                'driver_options' => [
                    1014 => false,
                ],
            ],
        ],
        'table_prefix' => '',
    ],
    'queue' => [
        // https://devdocs.magento.com/guides/v2.3/config-guide/cli/config-cli-subcommands-queue.html#start-message-queue-consumers
        // DEV mode: 0 => reduce memory by preventing long running consumers
        // Prod mode should be 1?
        'consumers_wait_for_messages' => 0,
    ],
    'crypt' => [
        'key' => 'aa3e2b9e1d2d7d03ba96cef6dbef70b9',
    ],
    'resource' => [
        'default_setup' => [
            'connection' => 'default',
        ],
    ],
    'x-frame-options' => 'SAMEORIGIN',
    'MAGE_MODE' => 'developer',
    'session' => [
        'save' => 'redis',
        'redis' => [
            'host' => 'redis',
            'port' => '6379',
            'password' => '',
            'timeout' => '2.5',
            'persistent_identifier' => '',
            'database' => '2',
            'compression_threshold' => '2048',
            'compression_library' => 'gzip',
            'log_level' => '3',
            'max_concurrency' => '6',
            'break_after_frontend' => '20',
            'break_after_adminhtml' => '30',
            'first_lifetime' => '600',
            'bot_first_lifetime' => '60',
            'bot_lifetime' => '7200',
            'disable_locking' => '0',
            'min_lifetime' => '60',
            'max_lifetime' => '2592000',
        ],
    ],
    'cache' => [
        'frontend' => [
            'default' => [
                'backend' => 'Magento\\Framework\\Cache\\Backend\\Redis',
                'backend_options' => [
                    'server' => 'redis',
                    'database' => '0',
                    'port' => '6379'
                ]
            ],
            'page_cache' => [
                'backend' => 'Magento\\Framework\\Cache\\Backend\\Redis',
                'backend_options' => [
                    'server' => 'redis',
                    'port' => '6379',
                    'database' => '1',
                    'compress_data' => '0'
                ]
            ]
        ],
        'allow_parallel_generation' => false
    ],
    'lock' => [
        'provider' => 'db',
        'config' => [
            'prefix' => null,
        ],
    ],
    'cache_types' => [
        'config' => 1,
        'layout' => 1,
        'block_html' => 1,
        'collections' => 1,
        'reflection' => 1,
        'db_ddl' => 1,
        'compiled_config' => 1,
        'eav' => 1,
        'customer_notification' => 1,
        'config_integration' => 1,
        'config_integration_api' => 1,
        'full_page' => 1,
        'target_rule' => 1,
        'config_webservice' => 1,
        'translate' => 1,
        'google_product' => 1,
        'vertex' => 1,
    ],
    'downloadable_domains' => [
        'localhost',
        'backend.sky-premium-pwa.test',
    ],
    'install' => [
        'date' => 'Wed, 3 June 2020 11:30:00 +07',
    ],
    // Currently, no neeed to use Varnish in PWA?
    // 'http_cache_hosts' => [
    //     [
    //         'host' => 'varnish',
    //         'port' => '80',
    //     ],
    // ],
];
