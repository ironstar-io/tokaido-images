Ironstar System Cron Container
=====

This cron container uses superchronic. It runs as 'tok' user and 
not as root. 

# Usage
This cron container runs pre-defined scripts for maintaining an Ironstar
environment, such as performing backups. 

# Logging
Cron daemon logs are sent to stdout and stderr. You can output 
logs from your cron jobs to `/tokaido/logs/cron/system-{{filename}}`

