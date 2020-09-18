#!/usr/bin/env bash
set -euxo pipefail

# Lookup the address of our syslog container, since HAProxy can't use hostnames
echo "Setting syslog address"
syslog_ip=${SYSLOG_IP:-$(dig +short syslog)}
sed -i "s/{{SYSLOG_IP}}/${syslog_ip}/g" /usr/local/etc/haproxy/haproxy.cfg

echo "Setting Varnish hostname"
varnish_hostname=${VARNISH_HOSTNAME:-varnish}
sed -i "s/{{VARNISH_HOSTNAME}}/${varnish_hostname}/g" /usr/local/etc/haproxy/haproxy.cfg

# use custom ssl certificates if they're supplied
if [ -f "/app/config/tls/tls.key" ]; then
    echo "Using existing TLS certificate"
    cat /app/config/tls/tls.key /app/config/tls/tls.crt > /app/ssl/default.pem
    chmod 660 /app/ssl/*
else
    echo "Creating TLS Certificate"
    tls_fqdn=${TLS_FQDN:-"*.local.tokaido.io"}
    openssl req -subj "/CN=${tls_fqdn}/O=Tokaido Hosting Platform./C=AU" -x509 -nodes -days 365 -newkey rsa:2048 -keyout /app/ssl/default-ssl.key -out /app/ssl/default-ssl.crt
    cat /app/ssl/default-ssl.key /app/ssl/default-ssl.crt > /app/ssl/default.pem
    chmod 660 /app/ssl/*
fi

echo "Starting HAProxy"
/usr/sbin/haproxy -f /usr/local/etc/haproxy/haproxy.cfg
