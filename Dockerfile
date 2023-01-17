FROM php:8.1-apache

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update \ 
    && apt install -y gawk libc-client-dev libkrb5-dev \
    libpng-dev \
    zlib1g-dev \
    postfix \
    # Configure php extensions
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    # Install php extensions
    && docker-php-ext-install \
    mysqli \
    imap \
    gd \
    # Enable mod_rewrite
    && a2enmod rewrite \
    # Cleanup unnecessary files
    && rm -rf /var/lib/apt/lists/*

COPY . /var/www/html
RUN chown -R www-data:www-data /var/www \
    && mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
