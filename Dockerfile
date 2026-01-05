FROM php:8.3-fpm

# System dependencies
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libxml2-dev libzip-dev nano \
    && docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath gd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copy Laravel source
COPY src/ /var/www/

# ✅ Create required Laravel dirs BEFORE composer
RUN mkdir -p storage/logs bootstrap/cache \
 && chown -R www-data:www-data /var/www \
 && chmod -R 775 storage bootstrap/cache

# ✅ Now install dependencies
RUN composer install --no-dev --optimize-autoloader

USER www-data

EXPOSE 9000
CMD ["php-fpm"]
