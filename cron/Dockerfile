FROM tokaido/php71:edge

ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.5/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=9aeb41e00cc7b71d30d33c57a2333f2c2581a201
RUN apt-get update -y \
    && curl -fsSLO "$SUPERCRONIC_URL" \
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
