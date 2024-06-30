FROM debian:bullseye

#Install REDIS
RUN apt update
RUN apt install redis -y

#Configure REDIS
RUN echo "\nbind 0.0.0.0\nport 6379\n" > /etc/redis/redis.conf
RUN echo "protected-mode no\n" >> /etc/redis/redis.conf

# Expose port 6379 for Redis communication
EXPOSE 6379

# Set the entry point to start the Redis server with the specified configuration file
ENTRYPOINT ["redis-server", "/etc/redis/redis.conf"]