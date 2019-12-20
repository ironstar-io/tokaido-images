ARG TOKAIDO_VERSION
FROM tokaido/php71:${TOKAIDO_VERSION}
ENV DEBIAN_FRONTEND noninteractive
COPY configs/.bash_profile /etc/skel/.bash_profile
COPY configs/.bashrc /etc/skel/.bashrc
LABEL io.ironstar.platform=tokaido
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008,DL3009,SC2155,DL3013
RUN apt-get update  \
    && apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --no-install-recommends \
        openssh-server \
        multitail \
        sendmail \
        locales-all \
    && wget -qO- https://deb.nodesource.com/setup_10.x | bash - \
    && wget -qO- https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" \
    && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && wget -qO- https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash \
    && bash -c 'source $HOME/.nvm/nvm.sh && nvm install --lts=carbon' \
    && bash -c 'source $HOME/.nvm/nvm.sh && nvm install --lts=dubnium' \
    && bash -c 'source $HOME/.nvm/nvm.sh && nvm alias default lts/dubnium' \
    && apt-get update \
    && apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --no-install-recommends \
        yarn \
        jq \
        nano \
        google-cloud-sdk \
        python-setuptools \
    && pip install --upgrade awscli \
    && /usr/bin/ssh-keygen -A  \
    && chmod 600 /etc/skel/.bash* \
    && cp /etc/skel/.bash_profile /home/tok/.bash_profile \
    && cp /etc/skel/.bashrc /home/tok/.bashrc \
    && chown tok:web /home/tok/.bash* \
    && chmod 600 /home/tok/.bash* \
    && mkdir -p /run/sshd  \
    && wget -O composer-setup.php https://getcomposer.org/installer && php composer-setup.php && mv composer.phar /usr/local/bin/composer && rm composer-setup.php  \
    && su - tok -c "/usr/local/bin/composer global require \"hirak/prestissimo\""  \
    && su - tok -c "/usr/local/bin/composer global require \"drush/drush\""  \
    && COMPOSER_HOME=/usr/local/drush/global COMPOSER_BIN_DIR=/usr/local/drush/global/bin COMPOSER_VENDOR_DIR=/usr/local/drush/global/vendor composer require drush/drush:^8 \
    && wget -O /tmp/drush.phar https://github.com/drush-ops/drush-launcher/releases/download/0.6.0/drush.phar \
    && mv /tmp/drush.phar /usr/local/bin/drush \
    && chmod 755 /usr/local/bin/drush \
    && chmod 750 /home/tok/.composer/vendor/drush/drush/drush

WORKDIR /tmp
RUN wget -O /tmp/redis-5.0.6.tar.gz http://download.redis.io/releases/redis-5.0.6.tar.gz \
    && tar xzf /tmp/redis-5.0.6.tar.gz -C /tmp/ \
    && cd /tmp/redis-5.0.6 \
    && make && make install \
    && rm -rf /tmp/*
WORKDIR /tokaido

COPY configs/sshd_config /etc/ssh/sshd_config
COPY configs/motd.sh /etc/motd.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 700 /usr/local/bin/entrypoint.sh \
    && chmod 755 /etc/motd.sh  \
    && rm /etc/motd

ENV SHELL /bin/bash
EXPOSE 22
CMD ["/usr/local/bin/entrypoint.sh"]
