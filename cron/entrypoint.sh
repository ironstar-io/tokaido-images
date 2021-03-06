#!/usr/bin/env bash
set -eo pipefail

if ! [[ -f /tokaido/site/.tok/cron/crontab ]]; then
    echo "WARN: No crontab found, creating an empty one"
    mkdir -p /tokaido/site/.tok/cron/
    touch /tokaido/site/.tok/cron/crontab
fi

# If a custom environment variable path exists, then inject those values
if [[ $(ls -l /tokaido/config/custom-env-vars/* 2>/dev/null) ]]; then
    printf "${YELLOW}Importing custom env vars from /tokaido/config/custom-env-vars/*${NC}\n"
    for e in /tokaido/config/custom-env-vars/*;
    do
        v=$(cat $e)
        printf "  ${YELLOW}Setting custom ENV $e$NC\n"
        export ${e##*/}="$v"
    done
fi

umask 002
supercronic /tokaido/site/.tok/cron/crontab