FROM debian:bookworm

# Install Hugo
RUN apt-get update && apt-get install -y \
    hugo \
    && rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /site /var/www/html

# Copy Hugo site source
COPY src/ /site/

# Set working directory
WORKDIR /site

# Always clean and rebuild (force fresh build)
RUN rm -rf /var/www/html/* && \
    hugo --destination /var/www/html --verbose

# Set permissions
RUN chown -R www-data:www-data /var/www/html

CMD ["tail", "-f", "/dev/null"]