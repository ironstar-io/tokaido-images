FROM tokaido/admin73:edge

ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.5/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=9aeb41e00cc7b71d30d33c57a2333f2c2581a201
RUN apt-get update -y \
    && apt-get install -y logrotate \
    && curl -fsSLO "$SUPERCRONIC_URL" \
    && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
    && chmod +x "$SUPERCRONIC" \
    && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
    && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic \
    && mkdir -p /tokaido/config/logrotate \
    && chown -R tok:web /tokaido/config/logrotate \
    && chmod 770 /tokaido/config/logrotate

COPY config/crontab /tokaido/config/logrotate/crontab
COPY config/logrotate.conf /tokaido/config/logrotate/logrotate.conf

WORKDIR /tmp

ENTRYPOINT ["supercronic", "/tokaido/config/logrotate/crontab"]
