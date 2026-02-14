# Guida Docker per Laravel + Filament

Questa guida ti aiuterà a containerizzare e condividere la tua applicazione Laravel con Filament.

## 📋 Prerequisiti

Sul computer dove vuoi far girare l'app (tuo o del tuo amico), serve solo:
- **Docker Desktop** installato ([Download qui](https://www.docker.com/products/docker-desktop))
- Git (opzionale, per clonare il repository)

## 🚀 Setup iniziale (Prima volta)

### 1. Prepara il file .env

Copia il file `.env.docker` in `.env`:

```bash
cp .env.docker .env
```

Oppure, se hai già un `.env`, assicurati che abbia queste configurazioni per Docker:

```env
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=laravel
DB_PASSWORD=password
```

### 2. Genera la chiave dell'applicazione (se non l'hai già)

```bash
# Se hai PHP installato localmente
php artisan key:generate

# OPPURE usando Docker (se non hai PHP locale)
docker run --rm -v $(pwd):/var/www composer:latest composer install --ignore-platform-reqs
docker run --rm -v $(pwd):/var/www php:8.2-cli php /var/www/artisan key:generate
```

## 🏗️ Avvio con Docker

### Build e avvio dei container

```bash
# Build delle immagini (solo la prima volta o dopo modifiche al Dockerfile)
docker-compose build

# Avvia i container in background
docker-compose up -d
```

Questo comando:
- Scaricherà tutte le immagini necessarie (PHP, MySQL, Nginx)
- Costruirà il container della tua app
- Installerà le dipendenze PHP e Node
- Avvierà MySQL e l'applicazione

### Verifica che tutto funzioni

```bash
# Controlla lo stato dei container
docker-compose ps

# Dovresti vedere qualcosa tipo:
# laravel-app    running    0.0.0.0:8000->80/tcp
# laravel-mysql  running    0.0.0.0:3306->3306/tcp
```

Apri il browser su: **http://localhost:8000**

## 📦 Comandi utili

### Eseguire comandi Artisan

```bash
# Esempio: eseguire le migrazioni
docker-compose exec app php artisan migrate

# Creare un utente Filament
docker-compose exec app php artisan make:filament-user

# Pulire la cache
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan config:clear
docker-compose exec app php artisan view:clear
```

### Accedere al container

```bash
# Entrare nel container dell'app
docker-compose exec app bash

# Entrare in MySQL
docker-compose exec mysql mysql -u laravel -ppassword laravel
```

### Vedere i log

```bash
# Log di tutti i servizi
docker-compose logs -f

# Log solo dell'app
docker-compose logs -f app

# Log solo di MySQL
docker-compose logs -f mysql
```

### Fermare e riavviare

```bash
# Ferma i container (ma mantiene i dati)
docker-compose stop

# Riavvia i container
docker-compose start

# Ferma e rimuove i container (i dati nel volume MySQL rimangono)
docker-compose down

# Ferma, rimuove i container E cancella i dati del database
docker-compose down -v
```

## 🔄 Workflow di sviluppo

### Modifiche al codice

I file della tua app sono montati come volume, quindi:
1. Modifichi il codice sul tuo computer normalmente
2. Le modifiche sono immediatamente visibili nel container
3. Ricarica la pagina nel browser per vedere i cambiamenti

### Modifiche alle dipendenze

Se aggiungi nuove dipendenze Composer o NPM:

```bash
# Per Composer
docker-compose exec app composer require nome/pacchetto

# Per NPM
docker-compose exec app npm install nuovo-pacchetto

# Ricompila gli asset
docker-compose exec app npm run build
```

### Modifiche al Dockerfile

Se modifichi il `Dockerfile` o le configurazioni in `docker/`:

```bash
# Rebuilda l'immagine
docker-compose build --no-cache

# Riavvia
docker-compose up -d
```

## 👥 Condividere l'app con il tuo amico

### Opzione 1: Inviare tutto il progetto

1. Zippa l'intera cartella del progetto (escluse le cartelle non necessarie)
2. Il tuo amico:
   - Scompatta il file
   - Installa Docker Desktop
   - Apre il terminale nella cartella del progetto
   - Esegue `docker-compose up -d`
   - Apre http://localhost:8000

### Opzione 2: Repository Git (consigliato)

1. Pusha il progetto su GitHub/GitLab (assicurati di avere `.env` nel `.gitignore`)
2. Il tuo amico:
   - Clona il repository
   - Copia `.env.docker` in `.env`
   - Esegue `docker-compose build`
   - Esegue `docker-compose up -d`

### Opzione 3: Immagine Docker (avanzato)

Se vuoi creare un'immagine già pronta:

```bash
# Build dell'immagine
docker-compose build

# Salva l'immagine in un file
docker save -o laravel-app.tar laravel-filament-app

# Invia il file .tar al tuo amico
# Il tuo amico carica l'immagine:
docker load -i laravel-app.tar
docker-compose up -d
```

## 🗄️ Database

### Import di un database esistente

Se hai un dump SQL da importare:

```bash
# Copia il file nel container MySQL
docker cp dump.sql laravel-mysql:/dump.sql

# Importalo
docker-compose exec mysql mysql -u laravel -ppassword laravel < /dump.sql
```

### Export del database

```bash
# Esporta tutto il database
docker-compose exec mysql mysqldump -u laravel -ppassword laravel > dump.sql
```

### Accesso diretto al database

Puoi connetterti a MySQL usando qualsiasi client (TablePlus, PHPMyAdmin, ecc.):

- Host: `localhost`
- Porta: `3306`
- Database: `laravel`
- Username: `laravel`
- Password: `password`

## 🐛 Troubleshooting

### Porta 8000 già in uso

Modifica il file `docker-compose.yml` nella sezione `app`:

```yaml
ports:
  - "8080:80"  # Cambia 8000 con 8080 o un'altra porta libera
```

### Porta 3306 già in uso

Se hai MySQL già installato localmente:

```yaml
ports:
  - "3307:3306"  # Usa la porta 3307
```

E aggiorna il `.env`:
```env
DB_PORT=3307
```

### Errori di permessi

```bash
# Ricrea i permessi corretti
docker-compose exec app chown -R laravel:laravel /var/www/storage /var/www/bootstrap/cache
docker-compose exec app chmod -R 775 /var/www/storage /var/www/bootstrap/cache
```

### MySQL non si avvia

```bash
# Rimuovi il volume e ricrea
docker-compose down -v
docker-compose up -d
```

### Rebuild completo

Se qualcosa non funziona:

```bash
# Ferma tutto
docker-compose down -v

# Pulisci le immagini
docker-compose build --no-cache

# Riavvia
docker-compose up -d
```

## 📝 Note importanti

1. **Non committare mai il file `.env`** con dati sensibili su Git
2. Il volume `mysql-data` persiste i dati anche dopo `docker-compose down`
3. Per resettare completamente: `docker-compose down -v` (cancella TUTTI i dati)
4. I log Laravel sono in `storage/logs/laravel.log`
5. I log del worker sono in `storage/logs/worker.log`

## 🎯 Comandi rapidi di riferimento

```bash
# Avvia
docker-compose up -d

# Ferma
docker-compose down

# Rebuild
docker-compose build

# Log
docker-compose logs -f

# Artisan
docker-compose exec app php artisan [comando]

# Composer
docker-compose exec app composer [comando]

# NPM
docker-compose exec app npm [comando]

# Bash nel container
docker-compose exec app bash

# MySQL client
docker-compose exec mysql mysql -u laravel -ppassword laravel
```

## ✅ Checklist per il tuo amico

- [ ] Installato Docker Desktop
- [ ] Clonato/scaricato il progetto
- [ ] Copiato `.env.docker` in `.env`
- [ ] Eseguito `docker-compose build`
- [ ] Eseguito `docker-compose up -d`
- [ ] Aperto http://localhost:8000
- [ ] Funziona tutto! 🎉
