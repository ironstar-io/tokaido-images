#!/usr/bin/env bash

set -eo pipefail
datetime=$(date "+%Y%m%d-%H%M%S%z")
log_filename="/tokaido/logs/cron/system.files-backup.$(date "+%Y%m%d").log"
sites_config="/tokaido/config/app/sites/sites"

if [[ -f /tokaido/config/system-cron/filesbackup_notification_hook ]]; then
    notif_webhook=$(cat /tokaido/config/system-cron/filesbackup_notification_hook)
fi

# Iterate over our list of configured drupal sites to find our backup targets
for s in $(< $sites_config jq '.[].name' | sed -e 's/\"//g'); do
    echo "Found site '$s' to backup"    

    targets="/tokaido/files/$s /tokaido/private/$s"
    dest="/tokaido/private/$s/ironstar-backups/drupal-files"
    mkdir -p "$dest"
  
    echo "[${datetime}] files backup commencing for site $s at" | tee -a "$log_filename"

    for target in $targets;
    do        
        target_path="${target//\//_}"  # change / to _ in backup path
        target_path="${target_path:1}"  # this will drop the leading _ from path

        backup_filename="$APP_ENV-$target_path-$datetime.tar.gz"        
        echo "[${datetime}] backing up $target (path: $target_path) to $dest/$backup_filename"        
        cd "$target"
        tar --exclude=ironstar-backups -czf "$dest"/"$backup_filename" ./* | tee -a "$log_filename"
        
        echo "[${datetime}] copying $backup_filename to S3" | tee -a "$log_filename"
        aws s3api put-object --bucket "$BACKUPS_BUCKET" --key $APP_ENV/drupal-files/${backup_filename} --body ${dest}/${backup_filename} --profile backups --server-side-encryption AES256 | tee -a "$log_filename" 

        echo "Validating uploaded backup"
        md5_local=$(md5sum /"$dest"/"$backup_filename" | cut -d' ' -f1)
        md5_remote=$(aws s3api head-object --bucket "$BACKUPS_BUCKET" --key $APP_ENV/drupal-files/"$backup_filename" --profile backups | jq .ETag | sed -e 's/\"//g; s/\\//g')
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
        
        echo "[${datetime}] cleaning up" | tee -a "$log_filename"
        rm -f "$dest"/"$backup_filename"
    done

done