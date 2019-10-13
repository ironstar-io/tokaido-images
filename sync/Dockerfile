FROM tokaido/base:stable
ENV DEBIAN_FRONTEND=noninteractive
ARG UNISON_VERSION=2.51.2

RUN apt update \
    && apt -y install ocaml gosu \
    && curl -L https://github.com/bcpierce00/unison/archive/v$UNISON_VERSION.tar.gz | tar zxv -C /tmp \
    && cd /tmp/unison-${UNISON_VERSION} \
    && sed -i -e 's/GLIBC_SUPPORT_INOTIFY 0/GLIBC_SUPPORT_INOTIFY 1/' src/fsmonitor/linux/inotify_stubs.c \
    && make \
    && cp src/unison src/unison-fsmonitor /usr/local/bin \
    && mkdir -p /tokaido/unison-metadata /tokaido/host-volume /home/tok/.unison \
    && chmod 2770 /tokaido/unison-metadata /tokaido/host-volume /tokaido/site \
    && chmod 2700 /home/tok/.unison \
    && chown tok:web /tokaido/unison-metadata /tokaido/host-volume /tokaido/site /home/tok/.unison

ENV TZ="UTC" \
    LANG="C.UTF-8" \
    UNISON_DIR="/tokaido/host-volume" \
    HOME="/tmp" \
    UNISON_USER="tok" \
    UNISON_GROUP="web" \
    UNISON_UID="1001" \
    UNISON_GID="1001"

# Install unison server script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chown tok:web /usr/local/bin/entrypoint.sh \
    && chmod 770 /usr/local/bin/entrypoint.sh

VOLUME /tokaido/host-volume

USER tok
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]