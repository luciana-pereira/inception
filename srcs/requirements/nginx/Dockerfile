FROM debian:bullseye

#Install NGINX enviroment
RUN apt update && apt upgrade -y
RUN apt install nginx -y

#Install openssl

RUN apt install openssl -y

# Create an RSA Private Key and CSR

#openssl – activates the OpenSSL software
#req – indicates that we want a CSR
#-x509 - auto signed.
#–new –newkey – generate a new key
#rsa:2048 – generate a 2048-bit RSA mathematical key
#–nodes – no DES, meaning do not encrypt the private key in a PKCS#12 file
#–keyout – indicates the domain you’re generating a key for
#–out – specifies the name of the file your CSR will be saved as
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-subj "/C=BR/ST=SP/L=São Paulo/O=42FR/OU=42SP/CN=lucperei.42.fr" \
-keyout /etc/ssl/nginx.key \
-out /etc/ssl/nginx.crt

#Copy .conf nginx file
COPY conf/my_nginx.conf /etc/nginx/conf.d/

#EntryPoint
#The Docker daemon ( dockerd ) listens for Docker API requests
#and manages Docker objects such as images, containers, networks, and volumes.
#A daemon can also communicate with other daemons to manage Docker services.
CMD ["nginx", "-g", "daemon off;"]