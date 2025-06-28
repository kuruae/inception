FROM debian:bookworm

# Update package list and install nginx and openssl
RUN apt-get update
RUN apt-get install -y nginx \
                      openssl

# Create directory for SSL certificates
RUN mkdir /etc/nginx/ssl

# Generate SSL certificates inside the container
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
       -out /etc/nginx/ssl/emagnani42.crt \
       -keyout /etc/nginx/ssl/emagnani42.key \
       -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=emagnani42/CN=emagnani42/"

# Copy nginx config
COPY ./conf/nginx.conf /etc/nginx/conf.d/

# Create nginx runtime directory
RUN mkdir -p /run/nginx

# Copy HTML file
COPY index.html /var/www/html/

# Only expose HTTPS port
EXPOSE 443

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]