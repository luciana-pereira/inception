FROM debian:bullseye

# Update packages and install wget
RUN apt-get update && \
    apt-get install -y wget

# Download cAdvisor version v0.37.0 from GitHub releases
RUN wget -O /usr/bin/cadvisor https://github.com/google/cadvisor/releases/download/v0.37.0/cadvisor

# Make the downloaded file executable
RUN chmod +x /usr/bin/cadvisor

# Expose port 8080
EXPOSE 8080

# Set the default command to start cAdvisor
CMD ["/usr/bin/cadvisor"]
