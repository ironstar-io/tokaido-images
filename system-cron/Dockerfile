FROM tokaido/drush:latest

ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.5/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=9aeb41e00cc7b71d30d33c57a2333f2c2581a201
RUN apt-get update -y \
    && curl -fsSLO "$SUPERCRONIC_URL" \
    && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
    && chmod +x "$SUPERCRONIC" \
    && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
    && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic \
    && mkdir -p /tokaido/logs/cron /tokaido/config/cron \
    && useradd -s /bin/bash -g web -m -K UMASK=002 cron \
    && usermod -p '*' cron \
    && chmod 700 /home/cron \
    && chown cron:root /home/cron/ -R \
    && chown -R cron:web /tokaido/logs/cron \
    && chmod 770 /tokaido/logs/cron

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY scripts/crontab /tokaido/config/cron/
COPY scripts/database-backup.sh /tokaido/config/cron/
COPY scripts/files-backup.sh /tokaido/config/cron/

RUN mkdir -p /tokaido/config/cron/ \
    && chown cron:web /tokaido/config/cron/ -R \
    && chown tok:web /usr/local/bin/entrypoint.sh \
    && chmod 770 /usr/local/bin/entrypoint.sh \
    && chmod 760 /tokaido/config/cron/*.sh

USER cron
WORKDIR /tokaido
CMD ["/usr/local/bin/entrypoint.sh"]
