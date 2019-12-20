FROM nginx:1.16
ENV DEBIAN_FRONTEND noninteractive

# General system config
RUN apt update  \
    && apt install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
        apt-transport-https \
        lsb-release \
        ca-certificates \
		bash \
        wget \
        vim \
        curl \
        telnet \
	    netcat \
        net-tools \
        iputils-ping \
        traceroute \
        iproute2 \
	&& mkdir -p /tokaido/proxy/config/client/conf.d /tokaido/proxy/config/nginx/errors/tokaido-errors/ \
    && mkdir -p /tokaido/proxy/config/client/tls \
	&& mkdir -p /var/cache/nginx \
	&& groupadd -g 1001 web  \
	&& userdel nginx \
	&& useradd -s /sbin/nologin -g web -u 1001 tok  \
    && useradd -s /sbin/nologin -d /var/cache/nginx -g web -u 1002 nginx  \
	&& chown tok:web /tokaido -R \
	&& chown nginx:web /var/cache/nginx \
	&& chmod 740 /var/cache/nginx

# Get Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /sbin/tini
RUN chmod 750 /sbin/tini \
    && chown tok:web /sbin/tini

# Copy the entrypoint and config scripts
COPY config/nginx.conf /tokaido/proxy/config/nginx/nginx.conf
COPY config/mime.types /tokaido/proxy/config/nginx/mime.types
ADD errors /tokaido/proxy/config/nginx/errors/tokaido-errors/
RUN chown nginx:web /tokaido/proxy/ -R \
	&& chmod 770 /tokaido/proxy/config -R

EXPOSE 5154

STOPSIGNAL SIGTERM

USER nginx
VOLUME /tokaido/

CMD ["/sbin/tini", "--", "nginx", "-c", "/tokaido/proxy/config/nginx/nginx.conf"]