FROM debian:bullseye

# Install necessary packages including PHP and PHP-FPM
RUN apt-get update && \
    apt-get install -y curl less \
    php7.4 php7.4-fpm php7.4-common \
    php7.4-json php7.4-gd php7.4-curl \
    php7.4-xml php7.4-mysql \
    php7.4-imap php7.4-pdo \
    php7.4-soap php7.4-ldap \
    php7.4-ctype php7.4-dom \
    php7.4-mbstring php7.4-zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create the /var/www/html directory
RUN mkdir -p /var/www/html

# Create the /run/php directory
RUN mkdir -p /run/php

# Download Adminer and set permissions
RUN curl -L -o /var/www/html/index.php https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php && \
    chown www-data:www-data /var/www/html/index.php

# Copy PHP-FPM configuration file
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Set the stop signal to SIGQUIT for graceful shutdown
STOPSIGNAL SIGQUIT

# Start PHP-FPM in the foreground
CMD ["php-fpm7.4", "--nodaemonize"]
