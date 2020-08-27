FROM debian:buster-slim
ENV DEBIAN_FRONTEND noninteractive
COPY configs/inputrc /etc/inputrc
LABEL io.ironstar.platform=tokaido
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008,DL3009
RUN apt-get update  \
    && apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --no-install-recommends \
	    netcat \
        apt-transport-https \
        build-essential \
        ca-certificates \
        curl \
        gawk\
        git \
        gnupg2 \
        iproute2 \
        iputils-ping \
        less \
        locales-all \
        lsb-release \
        mariadb-client \
        net-tools \
        netcat \
        openssh-client \
        python \
        python-pip \
        rsync \
        sed \
        telnet \
        traceroute \
        unzip \
        vim \
        wget \
    && echo "UTC" > /etc/timezone  \
    && echo exit 0 > /usr/sbin/policy-rc.d \
    && mkdir /etc/skel/.ssh  \
    && find /etc/skel -type d -a -print0 | xargs -0 chmod 700 \
    && find /etc/skel -type d -name ".*" -a -print0 | xargs -0 chmod 700 \
    && find /etc/skel -type f -a -print0 | xargs -0 chmod 600 \
    && find /etc/skel -type f -name ".*" -a -print0 | xargs -0 chmod 600 \
    && groupadd -g 1001 web  \
    && groupadd -g 1100 varnish \
    && useradd -m -s /bin/bash -g web -u 1001 tok  \
    && usermod -p '*' tok  \
    && chown tok:root /home/tok -R \
    && useradd -s /sbin/nologin -g web -u 1002 nginx  \
    && useradd -s /sbin/nologin -g web -u 1003 fpm  \
    && useradd -s /sbin/nologin -g varnish -u 1004 varnish  \
    && usermod -a -G web varnish \
    && useradd -s /sbin/nologin -g web -u 1005 haproxy  \
    && useradd -s /sbin/nologin -g web -u 1006 syslog \
    && mkdir -p /tokaido/logs/cron /tokaido/config /tokaido/files /tokaido/private /tokaido/site \
    && touch /tokaido/config/.env \
    && chmod 770 /tokaido/logs/ -R \
    && chmod 2770 /tokaido/files /tokaido/private \
    && chmod 750 /tokaido/config /tokaido/site \
    && chown tok:web /tokaido -R  \
    && chown tok:web /home/tok -R  \
    && chown tok:web /home/tok/.* -R

# Lock down the environment by ensuring that non-essential users and paths are sterilised
RUN userdel backup \
    && userdel daemon \
    && userdel games \
    && userdel gnats \
    && userdel irc \
    && userdel list \
    && userdel lp \
    && userdel man \
    && userdel news \
    && userdel proxy \
    && userdel sync \
    && userdel uucp \
    && userdel www-data \
    && groupdel audio \
    && groupdel cdrom \
    && groupdel dialout \
    && groupdel dip \
    && groupdel disk \
    && groupdel fax \
    && groupdel floppy \
    && groupdel kmem \
    && groupdel operator \
    && groupdel plugdev \
    && groupdel sasl \
    && groupdel shadow \
    && groupdel src \
    && groupdel ssh \
    && groupdel sudo \
    && groupdel tape \
    && groupdel users \
    && groupdel video \
    && groupdel voice

# Add tini to provide a simple init service and signal forwarding
ARG TINI_VERSION="v0.18.0"
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc /tmp/tini.asc
# warning "This key is not certified with a trusted signature!" from gpg verify is OK
RUN gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 \
    && gpg --batch --verify /tmp/tini.asc /usr/bin/tini \
    && chmod 555 /usr/bin/tini \
    && rm /tmp/tini.asc

# Quality of life improvements
COPY configs/inputrc /etc/inputrc
RUN echo "UTC" > /etc/timezone \
    && echo "stty werase undef" >> /etc/bash.bashrc \
    && echo "bind '\C-w:unix-filename-rubout'" >> /etc/bash.bashrc

# System cleanup and security hardening
RUN find /sbin -type f -print0 | xargs -0 chmod o-x \
    && find /usr/sbin -type f -print0 | xargs -0 chmod o-x \
    && find /var/lib/dpkg/ -type f -print0 | xargs -0 chmod o-x \
    && rm -rf /var/local /var/mail /var/tmp