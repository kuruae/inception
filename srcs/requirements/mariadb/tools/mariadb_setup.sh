#!/bin/bash

echo "=== MariaDB Setup Script Started ==="

# Debug: Print environment variables
dock

# Initialize database if it doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB in background for setup
echo "Starting MariaDB for setup..."
mysqld --user=mysql --bind-address=0.0.0.0 &
mysql_pid=$!

# Wait for MySQL to be ready
echo "Waiting for MariaDB to be ready..."
while ! mysqladmin ping -h localhost --silent; do
    sleep 1
done

# Check if database setup is needed
if ! mysql -u root -e "USE ${MYSQL_DATABASE};" 2>/dev/null; then
    echo "Setting up database and user..."
    mysql -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
else
    echo "Database already exists and is configured"
fi

echo "Database setup completed! MariaDB is ready."

# Wait for the MySQL process (keep container running)
wait $mysql_pid