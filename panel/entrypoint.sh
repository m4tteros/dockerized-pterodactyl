#!/bin/bash
set -e

echo "Starting Pterodactyl Panel in mode: USE_NGINX=${USE_NGINX:-false}"

# Ensure ownerships
chown -R www-data:www-data /app || true

if [ "${USE_NGINX:-false}" = "true" ]; then
    echo "Launching Nginx + PHP-FPM..."
    exec supervisord -c /etc/supervisor/conf.d/supervisord.conf
else
    echo "Launching PHP-FPM only..."
    exec php-fpm -F
fi
