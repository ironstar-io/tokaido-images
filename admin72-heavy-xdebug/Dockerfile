FROM tokaido/admin72-heavy:stable
COPY configs/php.ini /etc/php/7.2/php.ini
RUN apt-get update \
    && apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
        php7.2-xdebug \
