FROM php:8.3-fpm

# System dependencies
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev nano \
    && docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath gd

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copy Laravel source
COPY src/ /var/www/


# Only container-owned folders
RUN mkdir -p storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache
    
USER www-data

EXPOSE 9000
CMD ["php-fpm"]

