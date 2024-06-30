FROM debian:bullseye

# Update and upgrade the package list
RUN apt update && apt upgrade -y

# Install PHP and necessary extensions, along with the MariaDB client
RUN apt install php7.4 php7.4-fpm php7.4-mysql \
    php-common php7.4-cli php7.4-common \
    php7.4-json php7.4-opcache php7.4-readline \
    php7.4-mbstring php7.4-xml redis php-redis \
    php7.4-gd php7.4-curl mariadb-client -y

# Download wp-cli.phar for managing WordPress from the command line
RUN apt install wget -y
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

COPY tools/script.sh /tmp/script.sh
RUN chmod 777 /tmp/script.sh

#Create run directory to run PHP
RUN mkdir -p /run/php

#Create run directory to run WORDPRESS
RUN mkdir -p /var/www/wordpress

# Set permissions for the www-data user
RUN chown -R www-data:www-data /var/www/wordpress    
RUN chown -R www-data:www-data /etc/php/7.4/fpm/pool.d
RUN chown -R www-data:www-data /run/php

RUN sed -i "s/listen = \/run\/php\/php7.4-fpm.sock/listen = 0.0.0.0:9000/" /etc/php/7.4/fpm/pool.d/www.conf

# BONUS PART
# Install the Redis extension for PHP
RUN apt install php7.4-redis -y

# Set the working directory to /var/www/wordpress
WORKDIR /var/www/wordpress

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Set the entry point to run the configuration script
ENTRYPOINT ["/bin/sh", "/tmp/script.sh"]
