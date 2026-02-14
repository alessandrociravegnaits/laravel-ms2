#!/bin/sh
# script minimo di avvio: genera key se mancante, esegue migrate e avvia il server PHP integrato
set -e

# ...existing code...

if [ -z "$APP_KEY" ]; then
  echo "Generating APP_KEY"
  php artisan key:generate --force
fi

# Attendere la disponibilità del DB (opzionale, semplice loop)
if [ -n "$DB_HOST" ]; then
  echo "Waiting for DB at $DB_HOST:$DB_PORT..."
  n=0
  until nc -z "$DB_HOST" "${DB_PORT:-3306}" >/dev/null 2>&1 || [ $n -ge 15 ]; do
    n=$((n+1))
    sleep 1
  done
fi

# Eseguire migration in produzione (forzato). Rimuovi se preferisci eseguirle manualmente.
php artisan migrate --force || true

php artisan storage:link || true
php artisan config:cache || true

# Avvia server sulla porta fornita da Railway (porta di fallback 8080)
exec php -S 0.0.0.0:${PORT:-8080} -t public

