#!/bin/bash

echo "=== WordPress Setup Script Started ==="

# Debug: Print environment variables
echo "=== Environment Variables Debug ==="
echo "WORDPRESS_DB_NAME: $WORDPRESS_DB_NAME"
echo "WORDPRESS_DB_USER: $WORDPRESS_DB_USER"
echo "WORDPRESS_DB_HOST: $WORDPRESS_DB_HOST"
echo "=================================="

if [ -f ./wp-config.php ]; then
    echo "WordPress configuration file already exists. Skipping setup."
else
    echo "Downloading WordPress..."
    wp core download --allow-root

    echo "Waiting for database to be ready..."
    echo "Testing connection to: $WORDPRESS_DB_HOST with user: $WORDPRESS_DB_USER"
    
    while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" --silent; do
        echo "Waiting for database connection... (Host: $WORDPRESS_DB_HOST, User: $WORDPRESS_DB_USER)"
        sleep 2
    done

    echo "Creating wp-config with environment variables..."
    wp config create \
        --dbname=$WORDPRESS_DB_NAME \
        --dbuser=$WORDPRESS_DB_USER \
        --dbpass=$WORDPRESS_DB_PASSWORD \
        --dbhost=$WORDPRESS_DB_HOST \
        --allow-root

    echo "Installing WordPress..."
    wp core install \
        --url=$DOMAIN_NAME \
        --title="$WORDPRESS_TITLE" \
        --admin_user=$WORDPRESS_ADMIN_USER \
        --admin_password=$WORDPRESS_ADMIN_PASSWORD \
        --admin_email=$WORDPRESS_ADMIN_EMAIL \
        --allow-root

    echo "Creating additional WordPress user..."
    wp user create $WORDPRESS_USER_NAME $WORDPRESS_USER_EMAIL \
        --role=$WORDPRESS_USER_ROLE \
        --user_pass=$WORDPRESS_USER_PASSWORD \
        --allow-root

    # FOR BONUSES -- IM ADDING REDIS ONLY AFTER WP INSTALLATION
    echo "Setting up Redis caching..."
    wp plugin install redis-cache --activate --allow-root
    
    # setup redis in wp-config.php
    wp config set WP_REDIS_HOST 'redis' --allow-root
    wp config set WP_REDIS_PORT 6379 --allow-root
    wp config set WP_CACHE true --allow-root
    
    # Enable redis cache
    wp redis enable --allow-root
    echo "Redis caching configured and enabled!"

    echo "WordPress setup completed!"
fi

echo "Starting php-fpm..."
exec php-fpm8.2 -F