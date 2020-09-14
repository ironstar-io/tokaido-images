ARG TOKAIDO_VERSION
FROM tokaido/base:${TOKAIDO_VERSION}
LABEL io.ironstar.platform=tokaido
ARG DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# prevent Debian's PHP packages from being installed
RUN { \
		echo 'Package: php*'; \
		echo 'Pin: release *'; \
		echo 'Pin-Priority: -1'; \
	} > /etc/apt/preferences.d/no-debian-php

# dependencies required for running "phpize"
ARG BUILD_DEPS="\
        autoconf \
        dpkg-dev \
        file \
        g++ \
        gcc \
        libc-dev \
        make \
        pkg-config \
        re2c \
        libargon2-dev \
		libcurl4-openssl-dev \
		libedit-dev \
		libsodium-dev \
		libsqlite3-dev \
		libssl-dev \
		libxml2-dev \
		zlib1g-dev \
        bison \
        libbz2-dev \
        libc-client-dev \
        libgmp-dev \
        libkrb5-dev \
        libldap2-dev \
        libldb-dev \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libpq-dev \
        libpspell-dev \
        libedit-dev \
        libreadline-dev \
        libtidy-dev \
        libxslt-dev \
        libgpgme11-dev \
        libmagickwand-dev \
        libmemcached-dev \
        libyaml-dev \
        libzip-dev \
        libwebp-dev "

# persistent / runtime deps
# hadolint ignore=DL3008
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		$BUILD_DEPS \
		xz-utils \
        xfonts-base \
        xfonts-75dpi \
        postfix \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG PHP_INI_DIR=/tokaido/config/php
ARG PHP_INI_PATH=/tokaido/config/php/php.ini
ARG PHP_DIR=/usr/local/php
RUN mkdir -p "$PHP_INI_DIR/conf.d" "$PHP_INI_DIR/disabled" \
    && mkdir -p /usr/local/php/bin \
    && chown tok:web /usr/local/php/bin \
    && chmod 2775 /usr/local/php/bin

# Apply stack smash protection to functions using local buffers and alloca()
# Make PHP's main executable position-independent (improves ASLR security mechanism, and has no performance impact on x86_64)
# Enable optimization (-O2)
# Enable linker optimization (this sorts the hash buckets to improve cache locality, and is non-default)
# Adds GNU HASH segments to generated executables (this is used if present, and is much faster than sysv hash; in this configuration, sysv hash is also generated)
# https://github.com/docker-library/php/issues/272
# -D_LARGEFILE_SOURCE and -D_FILE_OFFSET_BITS=64 (https://www.php.net/manual/en/intro.filesystem.php)
ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
ENV PHP_CPPFLAGS="$PHP_CFLAGS"
ENV PHP_LDFLAGS="-Wl,-O1 -pie"

ENV GPG_KEYS CBAF69F173A0FEA4B537F470D66C9593118BCCB6 F38252826ACD957EF380D39F2F7956BC5DA04B5D

ENV PHP_VERSION 7.3.21
ARG PHP_URL="https://www.php.net/distributions/php-${PHP_VERSION}.tar.xz"
ARG PHP_ASC_URL="https://www.php.net/distributions/php-${PHP_VERSION}.tar.xz.asc"
ARG PHP_SHA256="4c8b065746ef776d84b7ae47908c21a79e3d4704b86b60d816716b8697c58ce9"
ARG PHP_MD5=""

RUN mkdir -p /usr/src/php
WORKDIR /usr/src
RUN curl -fsSL -o php.tar.xz "$PHP_URL" \
    && echo "$PHP_SHA256 *php.tar.xz" | sha256sum -c - \
    && curl -fsSL -o php.tar.xz.asc "$PHP_ASC_URL" \
	&& GNUPGHOME="$(mktemp -d)"; export GNUPGHOME \
	&& for key in $GPG_KEYS; do gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; done\
	&& gpg --batch --verify php.tar.xz.asc php.tar.xz \
	&& gpgconf --kill all \
	&& rm -rf "$GNUPGHOME"

# Extract the PHP source and compile it
RUN tar -Jxf /usr/src/php.tar.xz -C "/usr/src/php" --strip-components=1
WORKDIR /usr/src/php
RUN export \
		CFLAGS="$PHP_CFLAGS" \
		CPPFLAGS="$PHP_CPPFLAGS" \
		LDFLAGS="$PHP_LDFLAGS" \
    # https://bugs.php.net/bug.php?id=74125
	&& ln -sT "/usr/include/x86_64-linux-gnu/curl" /usr/local/include/curl \
    && ./configure \
		--build=x86_64-linux-gnu \
		--with-config-file-path="$PHP_INI_DIR" \
		--with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
        --prefix="$PHP_DIR" \
		--enable-option-checking=fatal \
        --enable-fpm \
        --with-fpm-user=tok \
        --with-fpm-group=web \
        --disable-cgi \
        --enable-bcmath \
        --enable-calendar \
        --enable-dba \
        --enable-exif \
        --enable-ftp \
        --enable-intl \
        --enable-mbstring \
        --enable-mysqlnd \
        --enable-opcache \
        --enable-pcntl \
        --enable-shmop \
        --enable-soap \
        --enable-sysvmsg \
        --enable-sysvsem \
        --enable-sysvshm \
        --enable-wddx \
        --enable-zip \
        --with-bz2 \
        --with-curl \
        --with-gd \
        --with-gettext \
        --with-gmp \
        --with-imap \
        --with-imap-ssl \
        --with-kerberos \
        --with-ldap \
        --with-mhash  \
        --with-mysqli \
        --with-openssl \
        --with-pcre-regex \
        --with-pdo-mysql \
        --with-pdo-pgsql \
        --with-pgsql  \
        --with-pspell \
        --with-readline \
        --with-sodium \
        --with-tidy \
        --with-xmlrpc \
        --with-xsl \
        --with-zlib \
        --with-jpeg-dir \
        --with-png-dir \
        --with-webp-dir


# compile PHP
RUN make -j "$(nproc)" \
    && find ./ -type f -name '*.a' -delete \
    && make install \
    && find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true \
	&& make clean \
    && cp -v php.ini-production ${PHP_INI_PATH} \
    && cp -v php.ini-production /tokaido/config/php/php-default.ini \
    && ln -s /usr/local/php/bin/php /usr/local/bin/php \
    && ln -s /usr/local/php/bin/pecl /usr/local/bin/pecl

# Extensions are needed for PECL installation steps
COPY config/extensions.ini ${PHP_INI_DIR}/conf.d/extensions.ini
RUN echo "include=/tokaido/config/php/extensions.ini" >> ${PHP_INI_PATH}

# Install additional php modules/extensions
# hadolint ignore=DL3008
RUN echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list \
    && curl -fsSL https://download.newrelic.com/548C16BF.gpg | apt-key add - \
    && apt-get update \
    && apt-get -y install newrelic-php5 --no-install-recommends \
    && echo "export PATH=$PATH:/usr/local/php/bin" >> /etc/skel/.bashrc \
    && echo "export PATH=$PATH:/usr/local/php/bin" >> /root/.bashrc \
    && echo "export PATH=$PATH:/usr/local/php/bin" >> /home/tok/.bashrc \
    && pecl config-set php_ini ${PHP_INI_PATH} \
    && pecl update-channels \
    && printf "\n" | pecl install imagick \
    && printf "\n" | pecl install propro \
    && printf "\n" | pecl install pecl_http \
    && printf "\n" | pecl install gnupg \
    && printf "\n" | pecl install yaml \
    && printf "\n" | pecl install memcached \
    && printf "\n" | pecl install redis \
    && printf "\n" | pecl install xdebug \
    && printf "\n" | pecl install oauth \
    && printf "\n" | pecl install igbinary \
    && printf "\n" | pecl install apcu \
    && printf "\n" | pecl install uploadprogress \
	&& rm -rf /tmp/pear ~/.pearrc

# Cleanup
RUN rm -rf /usr/src/php \
    && apt-get remove -y $BUILD_DEPS

RUN apt-get clean \
    && rm -rf /tmp/*

# Install custom modules and third-party extensions
RUN curl -s https://getcomposer.org/installer > composer-setup.php && /usr/local/bin/php composer-setup.php && mv composer.phar /usr/local/bin/composer && rm composer-setup.php  \
    && su - tok -c "/usr/local/bin/composer global require \"hirak/prestissimo\""  \
    && su - tok -c "/usr/local/bin/composer global require \"drush/drush\""  \
    && curl -sLo /usr/local/bin/drush https://github.com/drush-ops/drush-launcher/releases/download/0.6.0/drush.phar \
    && curl -sLO https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs952/ghostscript-9.52-linux-x86_64.tgz \
    && tar xzf ghostscript-9.52-linux-x86_64.tgz \
    && cp ghostscript-9.52-linux-x86_64/gs-952-linux-x86_64 /usr/local/bin/ghostscript \
    && curl -sLO https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb \
    && dpkg -i wkhtmltox_0.12.6-1.buster_amd64.deb \
    && cp /usr/local/bin/wkhtmltopdf /usr/bin \
    && cp /usr/local/bin/wkhtmltoimage /usr/bin \
    && chmod ug+x /usr/local/bin/drush /usr/local/bin/ghostscript /usr/local/bin/wkhtmltopdf /usr/local/bin/wkhtmltoimage \
    && chown tok:web /usr/local/bin/drush /usr/local/bin/ghostscript /usr/local/bin/wkhtmltopdf /usr/local/bin/wkhtmltoimage

# Copy config files
COPY start.sh /usr/local/bin/start.sh
COPY config/php-fpm.conf ${PHP_INI_DIR}/php-fpm.conf
COPY config/php.ini ${PHP_INI_PATH}
COPY config/www-pool.conf ${PHP_INI_DIR}/www-pool.conf
COPY config/newrelic.ini ${PHP_INI_DIR}/disabled/newrelic.ini
COPY config/xdebug.ini ${PHP_INI_DIR}/disabled/xdebug.ini

# Cleanup
RUN chown tok:web /usr/local/bin/start.sh \
    && chmod 555 /usr/local/bin/start.sh \
    && find /tokaido -type d -print0 | xargs -0 chmod 2750 \
    && mkdir -p /tokaido/logs/fpm \
    && chmod 770 /tokaido/logs/fpm \
    && chown tok:web /tokaido -R \
    && curl -sLo /usr/local/bin/ep https://github.com/kreuzwerker/envplate/releases/download/v0.0.8/ep-linux \
    && chmod 770 /usr/local/bin/ep \
    && chown tok:root /usr/local/bin/ep \
    && chmod o+x /usr/local/php/sbin/php-fpm

WORKDIR /tokaido/site
EXPOSE 9000
USER tok

CMD ["/usr/local/bin/start.sh"]