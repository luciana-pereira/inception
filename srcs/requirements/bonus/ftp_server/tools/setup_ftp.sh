#!/bin/bash

if [ -z "$FTP_USR" ] || [ -z "$FTP_PWD" ]; then
    echo "FTP_USR and FTP_PWD must be set"
    exit 1
fi

if [ ! -f /usr/local/bin/vsftpd.conf.bak ]; then

    # Create empty directory for the FTP server
    mkdir -p /var/run/vsftpd/empty

    # Create a user and a home directory for it
    adduser --disabled-password $FTP_USR --gecos ""
    mkdir -p /home/$FTP_USR/ftp

    # Set the user's password
    echo "$FTP_USR:$FTP_PWD" | chpasswd

    # Set the user's home directory
    chown -R $FTP_USR:$FTP_USR /home/$FTP_USR

    # Set permissions for the user's home directory
    chmod 755 /home/$FTP_USR/ftp

    # Add the user to the FTP server

    echo "$FTP_USR" | tee -a /etc/vsftpd.userlist

    # Copy the configuration file to the FTP server
    cp /etc/vsftpd.conf /etc/vsftpd.conf.bak
    mv /usr/local/bin/vsftpd.conf /etc/vsftpd.conf
    sed -i "s/^local_root=.*/local_root=\/home\/$FTP_USR\/ftp/" /etc/vsftpd.conf
    chmod 644 /etc/vsftpd.conf

    # Unset variables
    unset FTP_USR
    unset FTP_PWD

fi

# Start the FTP server
vsftpd /etc/vsftpd.conf