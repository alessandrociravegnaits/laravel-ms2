#!/bin/bash

# Attendi che MySQL sia pronto
echo "Waiting for MySQL to be ready..."
until php /var/www/artisan db:show 2>/dev/null; do
  echo "MySQL is unavailable - sleeping"
  sleep 2
done

echo "MySQL is up - executing migrations"

# Esegui le migrazioni
php /var/www/artisan migrate --force

# Ottimizza l'applicazione
php /var/www/artisan config:cache
php /var/www/artisan route:cache
php /var/www/artisan view:cache

# Assicurati che i permessi siano corretti
chown -R laravel:laravel /var/www/storage /var/www/bootstrap/cache
chmod -R 775 /var/www/storage /var/www/bootstrap/cache

echo "Starting supervisord..."
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
