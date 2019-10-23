#!/usr/bin/env bash
set -eo pipefail

drupal_root=${DRUPAL_ROOT:-docroot}
datetime=$(date "+%Y%m%d-%H%M%S%z")
log_filename="/tokaido/logs/cron/system.db-backup.$(date "+%Y%m%d").log"
sites_config="/tokaido/config/app/sites/sites"

if [[ ${DISABLE_DATABASE_BACKUPS} = "on" ]]; then
    echo "$datetime: Skipping backups because DISABLE_DATABASE_BACKUPS is 'on'" > $log_filename
    exit 0
fi

if [[ -f /tokaido/config/system-cron/databasebackup_notification_hook ]]; then
    notif_webhook=$(cat /tokaido/config/system-cron/databasebackup_notification_hook)
fi

# Iterate over our list of configured drupal sites to find our backup targets
for s in $(< $sites_config jq '.[].name' | sed -e 's/\"//g'); do
    echo "Found site '$s' to backup"
    backup_filename="$APP_ENV-$s-sql-dump-$datetime.sql"
    backup_path="/tokaido/private/$s/ironstar-backups/database"
    mkdir -p "$backup_path"

    echo "-----------------------" | tee -a "$log_filename"
    echo "[${datetime}] $s database backup commencing" | tee -a "$log_filename"

    cd /tokaido/site/"$drupal_root"/sites/"$s"
    echo "Navigated to $(pwd)"

    echo "Running drush sql-dump"
    drush sql-dump --gzip --extra-dump=--max_allowed_packet=1073741824 --result-file="$backup_path"/"$backup_filename" | tee -a "$log_filename"

    echo "Uploading the archive to S3"
    aws s3api put-object --bucket "$BACKUPS_BUCKET" --key $APP_ENV/sql-dump/${backup_filename}.gz --body ${backup_path}/${backup_filename}.gz --profile backups --server-side-encryption AES256 | tee -a "$log_filename"

    echo "Validating uploaded backup"
    md5_local=$(md5sum /"$backup_path"/"$backup_filename".gz | cut -d' ' -f1)
    md5_remote=$(aws s3api head-object --bucket "$BACKUPS_BUCKET" --key "$APP_ENV"/sql-dump/"$backup_filename".gz --profile backups | jq .ETag | sed -e 's/\"//g; s/\\//g')
    if [ "$md5_local" != "$md5_remote" ]; then
        echo "[${datetime}] $s validation of backup failed!" | tee -a "$log_filename"
        echo "[${datetime}] $s local md5sum $md5_local did not match remote md5sum $md5_remote"
        if [ -z ${notif_webhook+x} ]; then
            echo "Posting FAILED notification to Kanjou"
            curl -H "Content-Type: application/json" -X POST --data '{"status":"FAILED"}' https://ypshn11p72.execute-api.ap-southeast-2.amazonaws.com/rd/ironstar/dummy/204
        fi
    else
        echo "[${datetime}] $s backup validated successfully" | tee -a "$log_filename"
        echo "[${datetime}] $s local md5sum $md5_local matched remote md5sum $md5_remote"
        echo "Posting FINISHED notification to Kanjou"
        curl -H "Content-Type: application/json" -X POST --data '{"status":"FINISHED"}' https://ypshn11p72.execute-api.ap-southeast-2.amazonaws.com/rd/ironstar/dummy/204
    fi

    echo "[${datetime}] $s database backup finished" | tee -a "$log_filename"

    echo "Removing local backup file"
    rm /"$backup_path"/"$backup_filename".gz | tee -a "$log_filename"
done
