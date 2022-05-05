FROM php:8.0-fpm-alpine

# Install tools required for build stage
RUN apk add --update --no-cache \
    bash curl wget rsync ca-certificates openssl openssh git tzdata openntpd \
    libxrender fontconfig libc6-compat \
    mysql-client gnupg binutils-gold autoconf \
    g++ gcc gnupg libgcc linux-headers make

# Install composer
RUN curl sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer \
    && chmod 755 /usr/bin/composer

# Install additional PHP libraries
RUN docker-php-ext-install bcmath pdo_mysql

# Install libraries for compiling GD, then build it
RUN apk add --update --no-cache zlib-dev libzip-dev \
 && docker-php-ext-install zip


# Add ZIP archives support
RUN apk add --update --no-cache zlib-dev \
    && docker-php-ext-install zip

# Install xdebug
RUN pecl install xdebug-3.1.4 \
    && docker-php-ext-enable xdebug

# Enable Xdebug
ADD xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

WORKDIR /app
