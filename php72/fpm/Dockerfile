ARG TOKAIDO_VERSION
FROM tokaido/base:${TOKAIDO_VERSION}
ARG PHP_VERSION
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
        libwebp-dev "

# persistent / runtime deps
# hadolint ignore=DL3008
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		$BUILD_DEPS \
		xz-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG PHP_INI_DIR=/usr/local/php/etc
ARG PHP_DIR=/usr/local/php
RUN mkdir -p "$PHP_INI_DIR/conf.d" \
    && mkdir -p /usr/local/php/bin \
    && chown app:root /usr/local/php/bin \
    && chmod 2770 /usr/local/php/bin

# Apply stack smash protection to functions using local buffers and alloca()
# Make PHP's main executable position-independent (improves ASLR security mechanism, and has no performance impact on x86_64)
# Enable optimization (-O2)
# Enable linker optimization (this sorts the hash buckets to improve cache locality, and is non-default)
# Adds GNU HASH segments to generated executables (this is used if present, and is much faster than sysv hash; in this configuration, sysv hash is also generated)
# https://github.com/docker-library/php/issues/272
# -D_LARGEFILE_SOURCE and -D_FILE_OFFSET_BITS=64 (https://www.php.net/manual/en/intro.filesystem.php)
ARG PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
ARG PHP_CPPFLAGS="$PHP_CFLAGS"
ARG PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"

# Download and verify PHP source
ENV GPG_KEYS="1729F83938DA44E27BA0F4D3DBDB397470D12172 B1B44D8F021E4E2D6021E995DC9FF8D3EE5AF27F"
ENV PHP_URL="https://www.php.net/distributions/php-${PHP_VERSION}.tar.xz"
ENV PHP_ASC_URL="https://www.php.net/distributions/php-${PHP_VERSION}.tar.xz.asc"
ENV PHP_SHA256="0f160a3483ffce36be5962fab7bcf09d605ee66c5707df83e4195cb796bbb03a"

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
        --with-fpm-user=app \
        --with-fpm-group=app \
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

COPY config/extensions.ini /usr/local/php/etc/conf.d/extensions.ini

# compile PHP
RUN make -j "$(nproc)" \
    && find ./ -type f -name '*.a' -delete \
    && make install \
    && find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true \
	&& make clean \
    && cp -v php.ini-production "$PHP_INI_DIR/"php.ini

# Install additional modules/extensions
# hadolint ignore=DL3008
RUN echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list \
    && curl -fsSL https://download.newrelic.com/548C16BF.gpg | apt-key add - \
    && apt-get update \
    && apt-get -y install newrelic-php5 --no-install-recommends \
    && echo "export PATH=$PATH:/usr/local/php/bin" >> /etc/skel/.bashrc \
    && echo "export PATH=$PATH:/usr/local/php/bin" >> /root/.bashrc \
    && echo "export PATH=$PATH:/usr/local/php/bin" >> /home/app/.bashrc \
    && export PATH=$PATH:/usr/local/php/bin \
    && pecl config-set php_ini /usr/local/php/etc/php.ini \
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

# Cleanup
RUN apt-get clean \
    && rm -rf /tmp/*

# Copy config files
COPY init.sh /usr/local/bin/init.sh
COPY start.sh /usr/local/bin/start.sh
COPY config/php-fpm.conf /usr/local/php/etc/php-fpm.conf
COPY config/php.ini /usr/local/php/etc/php.ini
COPY config/www-pool.conf /usr/local/php/etc/www-pool.conf
COPY config/newrelic.ini /usr/local/php/etc/conf.d/newrelic.ini
COPY config/xdebug.ini /usr/local/php/etc/conf.d/xdebug.ini

# Hardened mode ensures that nothing is executable inside the running container
# Set N700_HARDENED to any value for the creation of '-hardened' images
RUN if [ "$N700_HARDENED" ]; then \
        find /bin -type f -perm -o=x -print0 | xargs -0 chmod o-x \
        && find /usr -type f -perm -o=x -print0 | xargs -0 chmod o-x \
        && find /sbin -type f -perm -o=x -print0 | xargs -0 chmod o-x \
        && find /var -type f -perm -o=x -print0 | xargs -0 chmod o-x \
        && cp /bin/bash /bin/hidden-shell \
        && sed -i 's/bash/hidden-shell/' /usr/local/bin/start.sh \
        && chmod a+x /bin/hidden-shell; fi

RUN chown tok:web /usr/local/bin/init.sh /usr/local/bin/start.sh \
    && chmod 555 /usr/local/bin/init.sh /usr/local/bin/start.sh \
    && find /tokaido -type d -print0 | xargs -0 chmod 2700 \
    && chown tok:web /tokaido -R \
    && curl -sLo /usr/local/bin/ep https://github.com/kreuzwerker/envplate/releases/download/v0.0.8/ep-linux \
    && chmod 770 /usr/local/bin/ep \
    && chown tok:root /usr/local/bin/ep \
    && chmod o+x /usr/local/php/sbin/php-fpm \
    && chmod o+x /usr/bin/tini

# ENV PHP_INI_DIR=/app/config/fpm/runtime
# ENV PHP_INI_SCAN_DIR=/app/config/fpm/runtime/conf.d
WORKDIR /tokaido/site
EXPOSE 9000
USER tok

CMD ["/usr/local/bin/start.sh"]