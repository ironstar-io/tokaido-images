ARG TOKAIDO_VERSION
ARG PHP_VERSION_SHORT
FROM tokaido/admin${PHP_VERSION_SHORT}:${TOKAIDO_VERSION}
LABEL io.ironstar.platform=tokaido
ARG IRONSTAR_CLI_VERSION=v0.7.0
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY configs/sudoers /etc/sudoers
COPY configs/fzf.bash /home/tok/.fzf.bash

# hadolint ignore=DL3003,DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
        ruby-full \
        sudo \
        bash-completion \
    && git clone --quiet --depth 1 https://github.com/junegunn/fzf.git /home/tok/.fzf \
    && cd /home/tok && ./.fzf/install \
    && chown tok:web /home/tok/.fzf -R \
    && chown tok:web /home/tok/.fzf.bash \
    && echo "" >> /home/tok/.bash_profile \
    && echo "source /home/tok/.fzf.bash" >> /home/tok/.bash_profile \
    && find /home/tok -type d -a -print0 | xargs -0 chmod 2700 \
    && find /home/tok -type d -iname ".*" -a -print0 | xargs -0 chmod 2700 \
    && find /home/tok -type f -a -print0 | xargs -0 chmod 600 \
    && find /home/tok -type f -iname ".*" -a -print0 | xargs -0 chmod 600 \
    && ln -s /usr/share/bash-completion/completions/git /etc/bash_completion.d/git-completion.bash \
    && chmod 750 /home/tok/.composer/vendor/drush/drush/drush \
    && chmod 700 /home/tok/.fzf/bin/fzf \
    && curl -sLo /usr/local/bin/iron https://github.com/ironstar-io/ironstar-cli/releases/download/${IRONSTAR_CLI_VERSION}/iron-linux \
    && chown tok:web /usr/local/bin/iron \
    && chmod 770 /usr/local/bin/iron \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV SHELL /bin/bash