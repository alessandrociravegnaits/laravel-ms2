# Usa l'immagine ufficiale PHP 8.2 con FPM
FROM php:8.2-fpm

# Argomenti per user ID e group ID
ARG uid=1000
ARG gid=1000

# Installa dipendenze di sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nginx \
    supervisor \
    nodejs \
    npm

# Pulisci cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Installa estensioni PHP necessarie per Laravel
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Ottieni l'ultima versione di Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Crea utente di sistema per eseguire i comandi Composer e Artisan
RUN groupadd -g ${gid} laravel && \
    useradd -u ${uid} -g laravel -m -s /bin/bash laravel

# Configura Nginx
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY docker/nginx/default.conf /etc/nginx/sites-available/default

# Configura Supervisor
COPY docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Imposta la directory di lavoro
WORKDIR /var/www

# Copia i file dell'applicazione
COPY --chown=laravel:laravel . /var/www

# Installa dipendenze PHP
RUN composer install --no-interaction --optimize-autoloader --no-dev

# Installa dipendenze Node e compila assets
RUN npm install && npm run build

# Imposta permessi corretti
RUN chown -R laravel:laravel /var/www && \
    chmod -R 755 /var/www/storage && \
    chmod -R 755 /var/www/bootstrap/cache

# Script di avvio
COPY docker/start.sh /usr/local/bin/start
RUN chmod +x /usr/local/bin/start

# Esponi la porta 80
EXPOSE 80

# Avvia Supervisor
CMD ["/usr/local/bin/start"]
