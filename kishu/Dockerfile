FROM debian:stable-slim
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update  \
    && useradd -m -s /bin/bash -u 1001 tok  \
    && usermod -p '*' tok

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 777 /usr/local/bin/entrypoint.sh

USER tok
WORKDIR /app
VOLUME /app/site
CMD ["/usr/local/bin/entrypoint.sh"]