ARG TOKAIDO_VERSION
ARG PHP_VERSION_SHORT
FROM tokaido/admin${PHP_VERSION_SHORT}:${TOKAIDO_VERSION}
LABEL io.ironstar.platform=tokaido
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.11/supercronic-linux-amd64
ARG SUPERCRONIC=supercronic-linux-amd64
ARG SUPERCRONIC_SHA1SUM=a2e2d47078a8dafc5949491e5ea7267cc721d67c

RUN curl -fsSLO "$SUPERCRONIC_URL" \
    && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
    && chmod +x "$SUPERCRONIC" \
    && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
    && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic \
    && mkdir -p /tokaido/logs/client-cron \
    && chown -R tok:web /tokaido/logs/client-cron \
    && chmod 770 /tokaido/logs/client-cron

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod 770 /usr/local/bin/entrypoint.sh && \
    chown tok:web /usr/local/bin/entrypoint.sh

USER tok
WORKDIR /tokaido/site

CMD ["/usr/local/bin/entrypoint.sh"]
