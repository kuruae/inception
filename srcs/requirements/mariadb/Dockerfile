FROM debian:buster

# Install MariaDB
RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories and set permissions
RUN mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql

# Copy configuration and script
COPY conf/mariadb.conf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/mariadb_setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/mariadb_setup.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/mariadb_setup.sh"]