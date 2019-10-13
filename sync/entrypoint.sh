#!/usr/bin/env bash
set -euo pipefail

# echo "Tokaido: setting ownership of /tokaido/unison-metadata directory"
# chown -R tok:web /tokaido/unison-metadata

# # Symlink .unison folder from user home directory to sync directory so that we only need 1 volume
# if [ ! -h "/tokaido/host-volume/.unison" ]; then
#     echo "Tokaido: setting unison metadata symlink"
#     ln -s /tokaido/unison-metadata /home/tok/.unison
# fi

# # Change data owner
# echo "Tokaido: setting ownership of /tokaido/host-volume and /tokaido/site"
# chown -R tok:web /tokaido/host-volume /tokaido/site

# Start process on path which we want to sync
cd /tokaido/host-volume

AUTO_SYNC=${AUTO_SYNC:-}

# Run unison server as UNISON_USER and pass signals through
if [ "$AUTO_SYNC" == "true" ]; then
    echo "Tokaido: performing a continuous sync"
    unison /tokaido/host-volume /tokaido/site -times -repeat watch -prefer newer -auto
else
    echo "Tokaido: performing a one-time sync"
    unison /tokaido/host-volume /tokaido/site -times -prefer newer -batch
fi