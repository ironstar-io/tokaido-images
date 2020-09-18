ARG TOKAIDO_VERSION
FROM tokaido/base:${TOKAIDO_VERSION}
ENV DEBIAN_FRONTEND noninteractive
COPY config/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf

RUN apt-get clean \
    && apt-get update  \
    && apt-get install -y --no-install-recommends -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
        debian-archive-keyring \
        gnupg \
        syslog-ng \
    && chown syslog /etc/syslog-ng -R \
    && mkdir -p /app/logs/nginx \
    && chown nginx:web /app/logs/nginx \
    && chmod 2770 /app/logs/nginx \
    && mkdir -p /app/logs/fpm \
    && chown tok:web /app/logs/fpm \
    && chmod 2770 /app/logs/fpm \
    && mkdir -p /app/logs/varnish \
    && chown varnish:web /app/logs/varnish \
    && chmod 2770 /app/logs/varnish \
    && mkdir -p /app/logs/haproxy \
    && chown haproxy:web /app/logs/haproxy \
    && chmod 2770 /app/logs/haproxy \
    && mkdir -p /app/logs/syslog  \
    && chown syslog:web /app/logs/syslog \
    && chmod 2770 /app/logs/syslog \
    && chmod 2770 /app/logs/ \
    && chown syslog:web /app/logs/


USER syslog
WORKDIR /app/logs
EXPOSE 5514
EXPOSE 5601
CMD ["/usr/sbin/syslog-ng", "-e", "-F", "--pidfile=/tmp/syslog-ng.pid", "--persist-file=/tmp/syslog-ng.persist", "--control=/tmp/syslog-ng.ctl"]