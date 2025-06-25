FROM debian:buster

# Update and install php-fpm and required packages
RUN apt-get update && apt-get install -y \
    php7.3-fpm \
    php7.3-mysql \
    php7.3-curl \
    php7.3-gd \
    php7.3-intl \
    php7.3-mbstring \
    php7.3-soap \
    php7.3-xml \
    php7.3-xmlrpc \
    php7.3-zip \
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

# Copy the www.conf file to php/7.3/fpm/pool.d/
COPY conf/www.conf /etc/php/7.3/fpm/pool.d/
COPY tools/wordpress_setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wordpress_setup.sh

# Create directory and set permissions
RUN mkdir -p /var/www/html
RUN chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html

EXPOSE 9000

CMD ["/usr/local/bin/wordpress_setup.sh"]