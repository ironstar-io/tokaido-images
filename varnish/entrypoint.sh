#!/usr/bin/env bash

set -eo pipefail

chmod 770 /app/logs/varnish
chown varnish:web /app/logs/varnish

VARNISH_BYPASS="${VARNISH_BYPASS:-false}"
VARNISH_PURGE_KEY="${VARNISH_PURGE_KEY:defaultlocalpurgekey}"
NGINX_HOSTNAME="${NGINX_HOSTNAME:-nginx}"

echo "config value 'VARNISH_BYPASS'     :: ${VARNISH_BYPASS}"
echo "config value 'VARNISH_PURGE_KEY'  :: ${VARNISH_PURGE_KEY}"
echo "config value 'NGINX_HOSTNAME'     :: ${NGINX_HOSTNAME}"

sed -i "s/{{.VARNISH_BYPASS}}/${VARNISH_BYPASS}/g" /etc/varnish/default.vcl
sed -i "s/{{.NGINX_HOSTNAME}}/${NGINX_HOSTNAME}/g" /etc/varnish/default.vcl
sed -i "s/{{.VARNISH_PURGE_KEY}}/${VARNISH_PURGE_KEY}/g" /etc/varnish/default.vcl

if [ ! -z ${IRONSTAR_HOSTED+x} ]; then
    echo "setting X-Ironstar-Hosted header"
    sed -i "s/{{.IRONSTAR_HOSTED}}/set resp.http.X-Ironstar-Hosted = \"true\";/g" /etc/varnish/default.vcl
else
    echo "setting X-Tokaido-Hosted header"
    sed -i "s/{{.IRONSTAR_HOSTED}}/set resp.http.X-Tokaido-Hosted = \"true\";/g" /etc/varnish/default.vcl
fi

exec /usr/bin/supervisord -n