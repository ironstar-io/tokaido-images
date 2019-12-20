#!/usr/bin/env bash

set -e
datetime=$(date "+%Y%m%d-%H%M%S%z")
log_filename="/tokaido/logs/cron/system.files-backup.$(date "+%Y%m%d").log"
sites_config="/tokaido/config/app/sites/sites"

if [[ -f /tokaido/config/system-cron/filesbackup_notification_hook ]]; then
    notif_webhook=$(cat /tokaido/config/system-cron/filesbackup_notification_hook)
fi

# Iterate over our list of configured drupal sites to find our backup targets
for s in $(< $sites_config jq '.[].name' | sed -e 's/\"//g'); do
    echo "Found site '$s' to backup"

    targets="/tokaido/storage/public/$s /tokaido/storage/private/$s"
    dest="/tokaido/storage/private/$s/ironstar-backups/drupal-files"
    mkdir -p "$dest"

    echo "[${datetime}] files backup commencing for site $s at" | tee -a "$log_filename"

    for target in $targets;
    do
        target_path="${target//\//_}"  # change / to _ in backup path
        target_path="${target_path:1}"  # this will drop the leading _ from path

        backup_filename="$APP_ENV-$target_path-$datetime.tar.gz"
        echo "[${datetime}] backing up $target (path: $target_path) to $dest/$backup_filename"
        cd "$target"
        set +e
        tar --exclude=ironstar-backups -czf "$dest"/"$backup_filename" ./* | tee -a "$log_filename"
        exitcode=$?

        if [ "$exitcode" != "1" ] && [ "$exitcode" != "0" ]; then
            echo "[${datetime}] unexpected exit code from tar" | tee -a "$log_filename"
            exit $exitcode
        fi
        set -e

        echo "[${datetime}] copying $backup_filename to S3" | tee -a "$log_filename"
        aws s3 cp --no-progress --profile backups --sse AES256 ${dest}/${backup_filename} "s3://"$BACKUPS_BUCKET"/$APP_ENV/drupal-files/${backup_filename}" 2>&1 | tee -a "$log_filename"

        echo "[${datetime}] cleaning up" | tee -a "$log_filename"
        rm -f "$dest"/"$backup_filename"
    done
done