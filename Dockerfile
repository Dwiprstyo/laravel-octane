# Use an official PHP image with FPM
FROM dunglas/frankenphp:latest

# Install necessary PHP extensions
RUN install-php-extensions pcntl pdo_mysql gd bz2 intl iconv bcmath opcache calendar pdo_pgsql zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory
WORKDIR /app

# Copy the application code
COPY . .

# Ensure the storage and cache directories are writable
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache

# Install application dependencies (optimized)
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Clear Laravel configuration cache
RUN php artisan config:cache

# Create symbolic link for storage
RUN php artisan storage:link

# Expose port 8000
EXPOSE 8000

# Set the entrypoint
ENTRYPOINT ["php", "artisan", "octane:frankenphp", "--host=0.0.0.0"]