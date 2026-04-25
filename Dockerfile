FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV VNC_PASSWORD=Dandi

# Install all required packages
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    nginx \
    curl \
    wget \
    nano \
    firefox \
    dbus-x11 \
    sudo \
    net-tools \
    openssh-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Setup VNC password
RUN mkdir -p /root/.vnc && \
    echo "Dandi" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Create VNC xstartup
RUN echo '#!/bin/bash\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nexec startxfce4' > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

# Create tmp dir
RUN mkdir -p /root/tmp

# Copy startup script
COPY start.sh /root/start.sh
RUN chmod +x /root/start.sh

EXPOSE 8080

CMD ["/root/start.sh"]
