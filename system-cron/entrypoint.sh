#!/usr/bin/env bash
set -euxo pipefail

# Set up backups profile
echo "Setting up an AWS CLI profile for backups for the tok user"
mkdir -p /home/cron/.aws
cat <<EOF > /home/cron/.aws/credentials
[backups]
aws_access_key_id = $BACKUPS_ACCESS_KEY
aws_secret_access_key = $BACKUPS_SECRET_KEY
region = $BACKUPS_AWS_REGION
EOF

umask 002
supercronic /tokaido/config/cron/crontab