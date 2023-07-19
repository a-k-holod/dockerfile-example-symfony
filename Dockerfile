# Use an ARM-compatible PHP image with FPM (PHP-FPM)
FROM php:8.1-fpm

# Install additional PHP extensions if needed
RUN docker-php-ext-install pdo pdo_mysql

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"

# Set the working directory inside the container
WORKDIR /var/www/html

# Copy the Symfony project files into the container
COPY . .

# Install Nginx
RUN apt-get update && apt-get install -y nginx

# Remove the default Nginx configuration
RUN rm /etc/nginx/sites-available/default
RUN rm /etc/nginx/sites-enabled/default

# Copy your Nginx configuration to the container
COPY nginx.conf /etc/nginx/sites-available/

# Create a symlink to enable the Nginx configuration
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/

# Expose the port for Nginx
EXPOSE 80

# Start PHP-FPM and Nginx
CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]
