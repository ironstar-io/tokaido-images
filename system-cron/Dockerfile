ARG TOKAIDO_VERSION
FROM tokaido/admin74-heavy:${TOKAIDO_VERSION}

ARG SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.11/supercronic-linux-amd64
ARG SUPERCRONIC=supercronic-linux-amd64
ARG SUPERCRONIC_SHA1SUM=a2e2d47078a8dafc5949491e5ea7267cc721d67c

RUN curl -fsSLO "$SUPERCRONIC_URL" \
    && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
    && chmod +x "$SUPERCRONIC" \
    && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
    && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic \
    && chown -R tok:web /app/logs/cron \
    && chmod 770 /app/logs/cron

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY scripts/crontab /app/config/cron/

RUN mkdir -p /app/config/cron/ \
    && chown tok:web /app/config/cron/ -R \
    && chown tok:web /usr/local/bin/entrypoint.sh \
    && chmod 770 /usr/local/bin/entrypoint.sh

WORKDIR /app
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
