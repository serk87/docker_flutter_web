# Install Operating system and dependencies
FROM ubuntu:20.04

ENV TZ=Europe/Moscow
RUN apt-get update  && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3 && \
    rm -rf /var/lib/apt/lists/*

# download Flutter SDK from Flutter Github repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter environment path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Run flutter doctor
RUN flutter doctor

# Enable flutter web
RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

# Copy files to container and build
COPY server.sh server.sh

RUN mkdir /app/
WORKDIR /app/

# Record the exposed port
EXPOSE 5000

# make server startup script executable and start the web server
RUN ["chmod", "+x", "/server.sh"]

ENTRYPOINT [ "/server.sh"]

HEALTHCHECK --interval=30s --timeout=2m \
  CMD curl -f http://localhost:5000 || exit 1