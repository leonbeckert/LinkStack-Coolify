# Use the official PHP image with Apache
FROM php:8.2-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-configure gd \
    && docker-php-ext-install gd

# Enable Apache modules
RUN a2enmod rewrite

# Set the working directory
WORKDIR /var/www/html

# Copy the application files
COPY . .

# Install Composer and dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --optimize-autoloader --no-dev

# Set environment variables
ENV APP_ENV=production
 \
    APP_DEBUG=false \
    APP_KEY=base64:random_key \
    DB_CONNECTION=mysql \
    DB_HOST=db:3306 \
    DB_PORT=3306 \
    DB_DATABASE=linkstack \
    DB_USERNAME=root_user \
    DB_PASSWORD=root_password \
    DB_PREFIX=linkstack_ \
    CACHE_DRIVER=file \
    SESSION_DRIVER=file

# Generate a new application key
RUN php artisan key:generate

# Set the correct permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
