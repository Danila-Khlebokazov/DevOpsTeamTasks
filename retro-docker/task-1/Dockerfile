# 32 bits Image
FROM i386/ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=host.docker.internal:0

# Install necessary tools and dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    libx11-6 \
    libxext6 \
    libxi6 \
    libgtk2.0-0 \
    libxt6 \
    libpangoxft-1.0 \
    libpangox-1.0 \
    libstdc++5:i386 \
    && apt-get clean

# Download and extract GTK+ 1.2
RUN wget https://old-releases.ubuntu.com/ubuntu/pool/universe/g/gtk+1.2/gtk+1.2_1.2.10.orig.tar.gz -O /tmp/gtk+1.2.tar.gz \
    && wget https://old-releases.ubuntu.com/ubuntu/pool/universe/g/gtk+1.2/libgtk1.2_1.2.10-18.1build2_i386.deb -O /tmp/libgtk1.2.deb \
    && wget https://old-releases.ubuntu.com/ubuntu/pool/universe/g/gtk+1.2/libgtk1.2-common_1.2.10-18.1build2_all.deb -O /tmp/libgtk1.2-common.deb \
    && wget https://archive.debian.org/debian/pool/main/g/glib1.2/libglib1.2ldbl_1.2.10-19_i386.deb -O /tmp/libglib1.2.deb \
    && wget http://security.ubuntu.com/ubuntu/pool/main/libx/libxp/libxp6_1.0.2-1ubuntu1_i386.deb -O /tmp/libxp6.deb \
    && wget http://security.ubuntu.com/ubuntu/pool/main/libx/libxp/libxp6_1.0.2-1ubuntu1_i386.deb -O /tmp/libxp6.deb \
    && tar -xzf /tmp/gtk+1.2.tar.gz -C /opt/ \
    && dpkg -i /tmp/libgtk1.2.deb /tmp/libgtk1.2-common.deb /tmp/libglib1.2.deb /tmp/libxp6.deb /tmp/libxp6.deb

# Download and extract Firefox 1.0.1
RUN wget https://download-installer.cdn.mozilla.net/pub/firefox/releases/1.0.1/linux-i686/en-US/firefox-1.0.1.tar.gz -O /tmp/mozilla.tar.gz \
    && gunzip -dc /tmp/mozilla.tar.gz | tar -xvf - -C /opt/

CMD ["/opt/firefox/firefox", "https://yandex.ru/games/"]

