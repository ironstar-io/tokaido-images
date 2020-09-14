#!/bin/bash
set -o pipefail -o errexit

# Colours
RED='\e[31m'
BLUE='\e[34m'
GREEN='\e[32m'
YELLOW='\e[33m'
PURPLE='\e[35m'
CYAN='\e[36m'
NC='\033[0m' # No Color

# Ensure that all files written have ug+rw
umask 002

printf "${BLUE}Running envplate to configure PHP${NC}\n"
ep /tokaido/config/php/php.ini
ep /tokaido/config/php/php-fpm.conf
ep /tokaido/config/php/www-pool.conf
ep /tokaido/config/php/conf.d/*

# Remove unnecessary variables from user visibility
unset KUBERNETES_SERVICE_PORT_HTTPS
unset KUBERNETES_SERVICE_PORT
unset KUBERNETES_PORT_443_TCP
unset KUBERNETES_PORT_443_TCP_PROTO
unset KUBERNETES_PORT_443_TCP_ADDR
unset KUBERNETES_SERVICE_HOST
unset KUBERNETES_PORT
unset KUBERNETES_PORT_443_TCP_PORT

if [[ $(ls -l /tokaido/config/custom-env-vars/* 2>/dev/null) ]]; then
    printf "${YELLOW}Importing custom env vars from /tokaido/config/custom-env-vars/*${NC}\n"
    for e in /tokaido/config/custom-env-vars/*;
    do
        v=$(cat $e)
        printf "  ${YELLOW}Setting ENV $e to $BLUE[$v]$NC\n"
        export ${e##*/}="$v"
    done
fi

if [ ${XDEBUG_REMOTE_ENABLE+x} ]; then
    printf "${YELLOW}Enabling XDebug Support${NC}\n"
    cp /tokaido/config/php/disabled/xdebug.ini /tokaido/config/php/conf.d/
fi

# Run post-deploy hooks if we're in a production environment
if [[ ! -z "$TOK_PROVIDER" ]]; then
    printf "${YELLOW}Running discovered post-deploy hooks from /tokaido/site/.tok/hooks/post-deploy/*.sh${NC}\n"
    for f in /tokaido/site/.tok/hooks/post-deploy/*.sh;
    do
        bash "$f" || true;
    done
fi

printf "${GREEN}Starting PHP FPM${NC}\n"
/usr/bin/tini -s -- /usr/local/php/sbin/php-fpm -F -c /tokaido/config/php/php.ini --fpm-config /tokaido/config/php/php-fpm.conf
