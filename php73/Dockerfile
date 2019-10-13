FROM tokaido/base:stable
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update  \
    && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg  \
    && sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'  \
    && apt-get update   \
    && apt-get install -y \
        php7.3 \
        php7.3-bcmath \
        php7.3-bz2 \
        php7.3-calendar \
        php7.3-ctype \
        php7.3-curl \
        php7.3-dba \
        php7.3-dom \
        php7.3-embed \
        php7.3-enchant \
        php7.3-exif \
        php7.3-ftp \
        php7.3-gd \
        php7.3-gettext \
        php7.3-gmp \
        php7.3-iconv \
        php7.3-imap \
        php7.3-imagick \
        php7.3-intl \
        php7.3-json \
        php7.3-ldap \
        php7.3-mbstring \
        php7.3-memcached \
        php7.3-mysqli \
        php7.3-mysqlnd \
        php7.3-odbc \
        php7.3-opcache \
        php7.3-pdo \
        php7.3-pgsql \
        php7.3-phar \
        php7.3-phpdbg \
        php7.3-posix \
        php7.3-pspell \
        php7.3-readline \
        php7.3-redis \
        php7.3-shmop \
        php7.3-simplexml \
        php7.3-snmp \
        php7.3-soap \
        php7.3-sockets \
        php7.3-sqlite3 \
        php7.3-sysvmsg \
        php7.3-sysvsem \
        php7.3-sysvshm \
        php7.3-tidy \
        php7.3-tokenizer \
        php7.3-wddx \
        php7.3-xml \
        php7.3-xmlreader \
        php7.3-xmlwriter \
        php7.3-xmlrpc \
        php7.3-xsl \
        php7.3-zip  \
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
