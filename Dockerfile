FROM composer:latest AS composer

FROM php:7.4-apache
USER root

RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip

RUN docker-php-ext-install \
    pdo_mysql \
    zip

# Copy the Composer binary from the Composer image (Stage 1) to the PHP image (Stage 2)
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Verify Composer installation
RUN composer --version

COPY . /var/www/

RUN chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite

WORKDIR /var/www/
RUN composer install-mvc

# # Set the port to 80
# EXPOSE 80

# # Executing supervisord
# CMD ["supervisord", "-n"]
EXPOSE 80
CMD ["apache2-foreground"]
