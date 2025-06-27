FROM debian:bookworm

# Update and install php-fpm and required packages
RUN apt-get update && apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-curl \
    php8.2-gd \
    php8.2-intl \
    php8.2-mbstring \
    php8.2-soap \
    php8.2-xml \
    php8.2-xmlrpc \
    php8.2-zip \
    php8.2-cli \
    curl \
    wget \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Create required directories
RUN mkdir -p /run/php
RUN mkdir -p /var/www/html

# Download and install wp-cli (updated method)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copy the www.conf file to php/8.2/fpm/pool.d/
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/
COPY tools/wordpress_setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wordpress_setup.sh

# Create directory and set permissions
RUN mkdir -p /var/www/html
RUN chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html

EXPOSE 9000

CMD ["/usr/local/bin/wordpress_setup.sh"]