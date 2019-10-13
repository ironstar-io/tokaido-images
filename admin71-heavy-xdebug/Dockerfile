FROM tokaido/admin71-heavy:edge
COPY configs/php.ini /etc/php/7.1/php.ini
RUN apt-get update \
    && apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
        php-xdebug \
