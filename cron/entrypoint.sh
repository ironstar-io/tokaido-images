#!/usr/bin/env bash
set -eo pipefail

printf "Running envplate to configure PHP\n"
ep /app/config/php/php.ini

if ! [[ -f /app/site/.tok/cron/crontab ]]; then
    echo "WARN: No crontab found"
    keepgoing=1
    trap '{ echo "sigint"; keepgoing=0; }' SIGINT

    while (( keepgoing )); do
        echo "sleeping"
        sleep 86400
    done
fi

# If a custom environment variable path exists, then inject those values
if [[ $(ls -l /app/config/custom-env-vars/* 2>/dev/null) ]]; then
    printf "Importing custom env vars from /app/config/custom-env-vars/*\n"
    for e in /app/config/custom-env-vars/*;
    do
        v=$(cat $e)
        printf "  Setting custom ENV $e\n"
        export ${e##*/}="$v"
    done
fi

umask 002
/usr/local/bin/supercronic -passthrough-logs /app/site/.tok/cron/crontab > /app/logs/cron.log