ARG TOKAIDO_VERSION
FROM tokaido/base:${TOKAIDO_VERSION}
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update  \
    && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg  \
    && sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'  \
    && apt-get update   \
    && apt-get install -y \
        libsodium-dev \
        libmcrypt-dev \
        php7.4 \
        php7.4-bcmath \
        php7.4-bz2 \
        php7.4-calendar \
        php7.4-ctype \
        php7.4-curl \
        php7.4-dba \
        php7.4-dev \
        php7.4-dom \
        php7.4-embed \
        php7.4-enchant \
        php7.4-exif \
        php7.4-ftp \
        php7.4-gd \
        php7.4-gettext \
        php7.4-gmp \
        php7.4-iconv \
        php7.4-imap \
        php7.4-imagick \
        php7.4-intl \
        php7.4-json \
        php7.4-ldap \
        php7.4-mbstring \
        php7.4-memcached \
        php7.4-mysqli \
        php7.4-mysqlnd \
        php7.4-odbc \
        php7.4-opcache \
        php7.4-pdo \
        php7.4-pgsql \
        php7.4-phar \
        php7.4-phpdbg \
        php7.4-posix \
        php7.4-pspell \
        php7.4-readline \
        php7.4-redis \
        php7.4-shmop \
        php7.4-simplexml \
        php7.4-snmp \
        php7.4-soap \
        php7.4-sockets \
        php7.4-sqlite3 \
        php7.4-sysvmsg \
        php7.4-sysvsem \
        php7.4-sysvshm \
        php7.4-tidy \
        php7.4-tokenizer \
        php7.4-xml \
        php7.4-xmlreader \
        php7.4-xmlwriter \
        php7.4-xmlrpc \
        php7.4-xsl \
        php7.4-zip  \
        python \
        python-pip \
        python-setuptools \
        ssmtp \
        xvfb \
        fontconfig \
        xfonts-75dpi \
        libxrender1 \
        ttf-dejavu \
        ttf-freefont \
        ttf-liberation \
        php-pear \
        php-dev \
        php-xml \
    && ln -sf /usr/bin/php7.4 /etc/alternatives/php \
    && pecl channel-update pecl.php.net \
    # Install ghostscript from source
    && wget https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs926/ghostscript-9.26.tar.gz \
    && tar xzf ghostscript-9.26.tar.gz \
    && cd ghostscript-9.26 \
    && ./configure \
    && make \
    && make install \
    && wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb \
    && dpkg -i  wkhtmltox_0.12.5-1.stretch_amd64.deb \
    && cp /usr/local/bin/wkhtmltopdf /usr/bin \
    && cp /usr/local/bin/wkhtmltoimage /usr/bin \
    && mkdir -p /run/php

COPY config/ssmtp.conf /tokaido/config/ssmtp/ssmtp.conf
RUN ln -s -f /tokaido/config/ssmtp/ssmtp.conf /etc/ssmtp/ssmtp.conf
