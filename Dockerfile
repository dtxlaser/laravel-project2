FROM php:8.3-fpm

# ----------------------------
# System dependencies
# ----------------------------
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev nano \
    && docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath gd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ----------------------------
# Composer
# ----------------------------
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# ----------------------------
# Working directory
# ----------------------------
WORKDIR /var/www

# Copy Laravel source
COPY src/ /var/www/

# ----------------------------
# Ensure directories exist
# ----------------------------
RUN mkdir -p storage bootstrap/cache vendor

# ----------------------------
# Install PHP dependencies as root
# ----------------------------
RUN composer install --no-dev --optimize-autoloader

# ----------------------------
# Set proper permissions
# ----------------------------
RUN chown -R www-data:www-data /var/www \
 && chmod -R 775 storage bootstrap/cache vendor

# Switch to non-root user
USER www-data

# Expose PHP-FPM
EXPOSE 9000
CMD ["php-fpm"]
