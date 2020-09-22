#!/usr/bin/env bash
set -euxo pipefail

umask 002
/usr/local/bin/supercronic -passthrough-logs /app/config/cron/crontab > /app/logs/system-cron.log