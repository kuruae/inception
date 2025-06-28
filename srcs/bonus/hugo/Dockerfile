# srcs/bonus/hugo/Dockerfile
FROM debian:bookworm

# Install Hugo only
RUN apt-get update && apt-get install -y \
    hugo \
    && rm -rf /var/lib/apt/lists/*

# Create site directory
WORKDIR /site

# Copy Hugo site source
COPY src/ /site/

# Build the static site
RUN hugo --destination /var/www/html

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Just serve the built files (no web server needed)
CMD ["tail", "-f", "/dev/null"]