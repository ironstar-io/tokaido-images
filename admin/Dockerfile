ARG TOKAIDO_VERSION
ARG PHP_VERSION_SHORT
FROM tokaido/php${PHP_VERSION_SHORT}:${TOKAIDO_VERSION}
LABEL io.ironstar.platform=tokaido
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY configs/.bash_profile /etc/skel/.bash_profile
COPY configs/.bashrc /etc/skel/.bashrc

# this container deliberately runs as root so SSH can run
# hadolint ignore=DL3002
USER root

ARG RUNLEVEL=1
ARG PHPRC=/app/config/php/php-default.ini
WORKDIR /tmp

COPY configs/sshd_config /etc/ssh/sshd_config
COPY configs/motd.sh /etc/motd.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 700 /usr/local/bin/entrypoint.sh \
    && chmod 755 /etc/motd.sh  \
    && rm /etc/motd \
    && rm /app/config/php/php-fpm.conf /app/config/php/www-pool.conf /app/config/php/disabled/newrelic.ini /usr/local/php/sbin/php-fpm

# hadolint ignore=DL3003,DL3008
RUN apt-get install -y --no-install-recommends build-essential \
    && curl -sO http://download.redis.io/redis-stable.tar.gz \
    && tar xvzf redis-stable.tar.gz \
    && cd redis-stable \
    && make \
    && cp src/redis-cli /usr/local/bin/ \
    && chmod 755 /usr/local/bin/redis-cli

# hadolint ignore=DL3008,DL3013
RUN apt-get update  \
    && apt-get install -y --no-install-recommends -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
        screen \
        openssh-server \
        locales-all \
        less \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash \
    && bash -c 'source $HOME/.nvm/nvm.sh && nvm install v8' \
    && bash -c 'source $HOME/.nvm/nvm.sh && nvm install v10' \
    && bash -c 'source $HOME/.nvm/nvm.sh && nvm install v12' \
    && bash -c 'source $HOME/.nvm/nvm.sh && nvm install v14' \
    && bash -c 'source $HOME/.nvm/nvm.sh && nvm alias default v12' \
    && apt-get update \
    && apt-get install -y --no-install-recommends -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
        yarn \
        jq \
        nano \
    && pip install --upgrade setuptools \
    && pip install --upgrade awscli \
    && /usr/bin/ssh-keygen -A  \
    && chmod 600 /etc/skel/.bash* \
    && cp /etc/skel/.bash_profile /home/tok/.bash_profile \
    && cp /etc/skel/.bashrc /home/tok/.bashrc \
    && chown tok:web /home/tok/.bash* \
    && chmod 600 /home/tok/.bash* \
    && mkdir -p /run/sshd  \
    && COMPOSER_HOME=/usr/local/drush/global COMPOSER_BIN_DIR=/usr/local/drush/global/bin COMPOSER_VENDOR_DIR=/usr/local/drush/global/vendor composer require drush/drush:^8 \
    && chmod 750 /home/tok/.composer/vendor/drush/drush/drush \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm /etc/ssh/ssh_host_dsa_key* /etc/ssh/ssh_host_ecdsa_key* /etc/ssh/ssh_host_ed25519_key*


RUN rm -rf /tmp/*

WORKDIR /app/site

ENV SHELL /bin/bash
EXPOSE 22
CMD ["/usr/local/bin/entrypoint.sh"]
