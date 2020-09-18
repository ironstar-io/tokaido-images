ARG TOKAIDO_VERSION
FROM tokaido/admin74-heavy:${TOKAIDO_VERSION}

ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.5/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=9aeb41e00cc7b71d30d33c57a2333f2c2581a201
RUN apt-get update -y \
    && curl -fsSLO "$SUPERCRONIC_URL" \
    && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
    && chmod +x "$SUPERCRONIC" \
    && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
    && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic \
    && mkdir -p /app/logs/cron /app/config/cron \
    && useradd -s /bin/bash -g web -m -K UMASK=002 cron \
    && usermod -p '*' cron \
    && chmod 700 /home/cron \
    && chown cron:root /home/cron/ -R \
    && chown -R cron:web /app/logs/cron \
    && chmod 770 /app/logs/cron

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY scripts/crontab /app/config/cron/

RUN mkdir -p /app/config/cron/ \
    && chown cron:web /app/config/cron/ -R \
    && chown tok:web /usr/local/bin/entrypoint.sh \
    && chmod 770 /usr/local/bin/entrypoint.sh
    # && chmod 760 /app/config/cron/*.sh

WORKDIR /app
CMD ["/usr/local/bin/entrypoint.sh"]
