FROM debian:bullseye

# Set working directory for subsequent commands
WORKDIR /var/hugo/static

# Update and upgrade packages, then install Hugo and Git
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    hugo git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Initialize a new Hugo site, clone a theme, create a new post, and build the site
RUN hugo new site /var/hugo/static \
    && cd /var/hugo/static \
    && git clone https://github.com/vaga/hugo-theme-m10c themes/m10c \
    && hugo new posts/presentation.md \
    && hugo -b https://lucperei.42.fr/static \
    && mkdir -p /var/hugo/me/content/about

# Copy configuration files and static assets to the container
COPY ./conf/config.toml /var/hugo/static/config.toml
COPY conf/presentation.md /var/hugo/static/content/posts/presentation.md
COPY conf/about.md /var/hugo/static/content/about/index.md
COPY ./conf/avatar.jpg /var/hugo/static/themes/m10c/static/avatar.jpg
COPY ./conf/inception-container.jpeg /var/hugo/static/themes/m10c/static/inception-container.jpeg

# Expose port 1313 for serving the Hugo site
EXPOSE 1313

# Set the default command to start Hugo server
#     "--bind=0.0.0.0", \   Bind to all interfaces
#     "--baseURL=https://lucperei.42.fr/static", \  Base URL for the site
#     "-p", "1313", \  # Port number
#     "--logFile=/dev/stdout", \   Log output to stdout
#     "--appendPort=false"]   Do not append port to baseURL
CMD ["hugo", "server", \
     "--bind=0.0.0.0", \  
     "--baseURL=https://lucperei.42.fr/static", \  
     "-p", "1313", \  
     "--logFile=/dev/stdout", \ 
     "--appendPort=false"] 
