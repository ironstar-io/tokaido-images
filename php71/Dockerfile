FROM tokaido/base:stable
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update  \
    && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg  \
    && sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'  \
    && apt-get update   \
    && apt-get install -y \
        php7.1 \
        php7.1-bcmath \
        php7.1-bz2 \
        php7.1-calendar \
        php7.1-ctype \
        php7.1-curl \
        php7.1-dba \
        php7.1-dom \
        php7.1-embed \
        php7.1-enchant \
        php7.1-exif \
        php7.1-ftp \
        php7.1-gd \
        php7.1-gettext \
        php7.1-gmp \
        php7.1-iconv \
        php7.1-imap \
        php7.1-imagick \
        php7.1-intl \
        php7.1-json \
        php7.1-ldap \
        php7.1-mbstring \
        php7.1-mcrypt \
        php7.1-memcached \
        php7.1-mysqli \
        php7.1-mysqlnd \
        php7.1-odbc \
        php7.1-opcache \
        php7.1-pdo \
        php7.1-pgsql \
        php7.1-phar \
        php7.1-phpdbg \
        php7.1-posix \
        php7.1-pspell \
        php7.1-readline \
        php7.1-redis \
        php7.1-shmop \
        php7.1-simplexml \
        php7.1-snmp \
        php7.1-soap \
        php7.1-sockets \
        php7.1-sqlite3 \
        php7.1-sysvmsg \
        php7.1-sysvsem \
        php7.1-sysvshm \
        php7.1-tidy \
        php7.1-tokenizer \
        php7.1-wddx \
        php7.1-xml \
        php7.1-xmlreader \
        php7.1-xmlwriter \
        php7.1-xmlrpc \
        php7.1-xsl \
        php7.1-zip  \
        ssmtp \
        xvfb \
        fontconfig \
        xfonts-75dpi \
        libxrender1 \
        ttf-dejavu \
        ttf-freefont \
        ttf-liberation \
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
