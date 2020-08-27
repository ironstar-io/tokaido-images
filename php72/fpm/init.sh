#!/usr/bin/env bash
set -o pipefail -o errexit

# Colours
RED='\e[31m'
BLUE='\e[34m'
GREEN='\e[32m'
YELLOW='\e[33m'
PURPLE='\e[35m'
CYAN='\e[36m'
NC='\033[0m' # No Color

############################
# Copy Config Files to writeable location
# The PHP FPM image stores config files in /usr/local/php/etc as part of the image
# but this path is read-only when run inside Kubernetes, so they can't be updated in-place
# Instead these are copied to a writeable location, modified, and then have their permissions
# reset so that they cannot be written to again.
############################

printf "${YELLOW}Copying default config to writeable location...${NC}\n"
mkdir -p /app/config/fpm/runtime/conf.d
cp -r /usr/local/php/etc/php-fpm.conf /app/config/fpm/runtime/
cp -r /usr/local/php/etc/php.ini /app/config/fpm/runtime/
cp -r /usr/local/php/etc/www-pool.conf /app/config/fpm/runtime/
cp -r /usr/local/php/etc/conf.d/extensions.ini /app/config/fpm/runtime/conf.d/

if [ ${NOZOMI_XDEBUG_REMOTE_ENABLE+x} ]; then
    printf "${YELLOW}Enabling XDebug Support${NC}\n"
    cp -r /usr/local/php/etc/conf.d/xdebug.ini /app/config/fpm/runtime/conf.d/
fi

if [ ${NOZOMI_NEWRELIC_LICENSE_KEY+x} ]; then
    printf "${YELLOW}Enabling NewRelic Support${NC}\n"
    cp -r /usr/local/php/etc/conf.d/newrelic.ini /app/config/fpm/runtime/conf.d/
fi

ep -v /app/config/fpm/runtime/*

# Load any environment variables (this will override any set by Docker)
if [[ -f /app/config/env/.custom ]]; then
   printf "Importing environment variables from /app/config/env/.custom\n"
   set -o allexport
   source /app/config/env/.custom \
   set +o allexport
fi

# Set default permissions for fpm log files
touch /app/logs/php-error.log
touch /app/logs/fpm-error.log
touch /app/logs/fpm-access.log
touch /app/logs/fpm-slow.log
touch /app/logs/drupal.log

# Ensure that FPM can write to existing logs, but can't create new files in the log path
chown root:app /app/logs -R
find /app/logs -type d -print0 | xargs -0 chmod 750
find /app/logs -type f -print0 | xargs -0 chmod 660

# Ensure that FPM can read from runtime config, but can't modify it
chown root:app /app/config/fpm/runtime -R
find /app/config/fpm/runtime/ -type d -print0 | xargs -0 chmod 750
find /app/config/fpm/runtime/ -type f -print0 | xargs -0 chmod 640

printf "${GREEN}PHP-FPM environment ready${NC}"