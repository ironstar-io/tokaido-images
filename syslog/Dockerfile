FROM tokaido/base:stable
ENV DEBIAN_FRONTEND noninteractive
COPY config/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf

RUN apt-get update  \
    && apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \	    
        debian-archive-keyring \
        gnupg \
        syslog-ng \
    && chown syslog /etc/syslog-ng -R \
    && mkdir -p /tokaido/logs/nginx \
    && chown nginx:web /tokaido/logs/nginx \
    && chmod 2770 /tokaido/logs/nginx \
    && mkdir -p /tokaido/logs/fpm \
    && chown tok:web /tokaido/logs/fpm \
    && chmod 2770 /tokaido/logs/fpm \
    && mkdir -p /tokaido/logs/varnish \
    && chown varnish:web /tokaido/logs/varnish \
    && chmod 2770 /tokaido/logs/varnish \
    && mkdir -p /tokaido/logs/haproxy \
    && chown haproxy:web /tokaido/logs/haproxy \
    && chmod 2770 /tokaido/logs/haproxy \
    && mkdir -p /tokaido/logs/syslog  \
    && chown syslog:web /tokaido/logs/syslog \
    && chmod 2770 /tokaido/logs/syslog \
    && chmod 2770 /tokaido/logs/ \
    && chown syslog:web /tokaido/logs/ 
    
    
USER syslog
WORKDIR /tokaido/logs
EXPOSE 5514
EXPOSE 5601
CMD ["/usr/sbin/syslog-ng", "-e", "-F", "--pidfile=/tmp/syslog-ng.pid", "--persist-file=/tmp/syslog-ng.persist", "--control=/tmp/syslog-ng.ctl"]