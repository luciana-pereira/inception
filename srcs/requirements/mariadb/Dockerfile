FROM debian:bullseye

# Install mariadb environment
RUN apt update && apt upgrade -y

# Install MariaDB server
RUN apt install mariadb-server -y

# Update configuration file
COPY /conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Set permissions for the configuration file
RUN chmod 644 /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy the script to configure MariaDB users and password
COPY /tools/script.sh /tmp/

# Expose port 3306 for MariaDB
EXPOSE 3306

# Set the entry point to run the configuration script
ENTRYPOINT ["/bin/sh", "/tmp/script.sh"]
