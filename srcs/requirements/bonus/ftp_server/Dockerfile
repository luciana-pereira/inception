FROM		debian:bullseye

# Define build arguments passed from docker-compose.yml
ARG			FTP_USR
ARG			FTP_PWD

# Set environment variables
ENV			FTP_USR=${FTP_USR}
ENV			FTP_PWD=${FTP_PWD}

# Update and upgrade system & install FTP
RUN			apt -y update && apt -y upgrade
RUN			apt -y install vsftpd ftp

# Set up FTP
COPY		./conf/vsftpd.conf /usr/local/bin/
COPY		./tools/setup_ftp.sh /usr/local/bin/
RUN			chmod 755 /usr/local/bin/setup_ftp.sh

# Expose port
EXPOSE		20 21 21100-21111

# Run FTP
ENTRYPOINT	[ "bash", "/usr/local/bin/setup_ftp.sh" ]