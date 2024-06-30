#!/bin/bash

# Check if the database directory does not exist
if [ ! -d "/var/lib/mysql/${MARIADB_DATABASE}" ]; then
    mysql_install_db --user=mysql --datadir="/var/lib/mysql" > /dev/null
    chown -R mysql:mysql /var/lib/mysql

    service mariadb start

    mysql --user=root --password="" <<-EOF
    CREATE DATABASE ${MARIADB_DATABASE};
    USE ${MARIADB_DATABASE};
    GRANT ALL ON ${MARIADB_DATABASE}.* TO '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
    GRANT ALL ON ${MARIADB_DATABASE}.* TO '${MARIADB_USER}'@'localhost' IDENTIFIED BY '${MARIADB_PASSWORD}';
    FLUSH PRIVILEGES;
    DELETE FROM mysql.user WHERE user='';
    DELETE FROM mysql.user WHERE user='root' AND host NOT IN('localhost', '127.0.0.1', '::1');
    DROP DATABASE IF EXISTS test;
    DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
    FLUSH PRIVILEGES;
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOF
    sed -i "s/password =/password = ${MARIADB_ROOT_PASSWORD}/g" /etc/mysql/debian.cnf
    service mariadb stop
fi

/usr/bin/mysqld_safe --user=mysql --datadir=/var/lib/mysql