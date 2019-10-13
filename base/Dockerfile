FROM debian:stretch-slim
ENV DEBIAN_FRONTEND noninteractive
COPY configs/inputrc /etc/inputrc
LABEL io.ironstar.platform=tokaido
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008,DL3009
RUN apt-get update  \
    && apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --no-install-recommends \
	    netcat \
        apt-transport-https \
        ca-certificates \
        curl \
        git \
        iproute2 \
        iputils-ping \
        lsb-release \
        mysql-client \
        net-tools \
        python \
        python-pip \
        rsync \
        telnet \
        traceroute \
        unzip \
        vim \
        wget \
    && echo "UTC" > /etc/timezone  \
    && mkdir /etc/skel/.ssh  \
    && find /etc/skel -type d -a -print0 | xargs -0 chmod 700 \
    && find /etc/skel -type d -name ".*" -a -print0 | xargs -0 chmod 700 \
    && find /etc/skel -type f -a -print0 | xargs -0 chmod 600 \
    && find /etc/skel -type f -name ".*" -a -print0 | xargs -0 chmod 600 \
    && groupadd -g 1001 web  \
    && useradd -m -s /bin/bash -g web -u 1001 tok  \
    && usermod -p '*' tok  \
    && chown tok:root /home/tok -R \
    && useradd -s /sbin/nologin -g web -u 1002 nginx  \
    && useradd -s /sbin/nologin -g web -u 1003 fpm  \
    && useradd -s /sbin/nologin -g web -u 1004 varnish  \
    && useradd -s /sbin/nologin -g web -u 1005 haproxy  \
    && useradd -s /sbin/nologin -g web -u 1006 syslog \
    && deluser www-data  \
    && mkdir -p /tokaido/logs/cron /tokaido/config /tokaido/files /tokaido/private /tokaido/site \
    && touch /tokaido/config/.env \
    && chmod 770 /tokaido/logs/ -R \
    && chmod 2770 /tokaido/files /tokaido/private \
    && chmod 750 /tokaido/config /tokaido/site \
    && chown tok:web /tokaido -R  \
    && chown tok:web /home/tok -R  \
    && chown tok:web /home/tok/.* -R
