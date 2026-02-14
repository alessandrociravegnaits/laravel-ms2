# 📦 Struttura Docker Completa per Laravel + Filament

## 📁 File e Cartelle Creati

```
tua-app-laravel/
├── docker/                          # Configurazioni Docker
│   ├── nginx/
│   │   ├── nginx.conf              # Configurazione Nginx principale
│   │   └── default.conf            # Virtual host per Laravel
│   ├── php/
│   │   └── local.ini               # Configurazione PHP personalizzata
│   ├── mysql/
│   │   └── my.cnf                  # Configurazione MySQL
│   ├── supervisor/
│   │   └── supervisord.conf        # Gestisce PHP-FPM, Nginx, Queue Worker
│   └── start.sh                    # Script di avvio container
│
├── Dockerfile                       # Definisce l'immagine dell'applicazione
├── docker-compose.yml              # Orchestrazione dei container
├── .dockerignore                   # File da escludere dal build
├── .env.docker                     # Template ambiente per Docker
│
├── Makefile                        # Comandi abbreviati (opzionale)
├── setup.sh                        # Script di setup automatico
│
├── README-DOCKER.md                # Guida completa
└── QUICK-START.md                  # Guida rapida
```

## 🏗️ Architettura dei Container

### 1. Container `app` (Laravel)
- **Immagine**: PHP 8.2 FPM + Nginx
- **Porta**: 8000 → 80
- **Contiene**:
  - PHP 8.2 con estensioni necessarie
  - Nginx per servire l'applicazione
  - Supervisor per gestire i processi
  - Queue worker per i job
  - Node.js e NPM per compilare asset

### 2. Container `mysql` (Database)
- **Immagine**: MySQL 8.4
- **Porta**: 3306
- **Volume**: Dati persistenti in `mysql-data`
- **Credenziali default**:
  - Database: `laravel`
  - Username: `laravel`
  - Password: `password`

### 3. Container `node` (Opzionale)
- **Profilo**: `dev`
- Per sviluppo con hot-reload Vite
- Attivabile con: `docker-compose --profile dev up`

## ⚙️ Caratteristiche

### ✅ Cosa fa automaticamente
1. **Installazione dipendenze**: Composer e NPM
2. **Build assets**: Compila CSS e JS con Vite
3. **Migrazioni**: Esegue `php artisan migrate` all'avvio
4. **Ottimizzazione**: Cache di config, route e view
5. **Queue Worker**: Gestisce i job in background
6. **Permessi**: Imposta permessi corretti su storage/

### 🔧 Personalizzazioni

#### PHP (docker/php/local.ini)
- Upload: 40MB
- Memory: 256MB
- Timeout: 600s
- Timezone: Europe/Rome

#### MySQL (docker/mysql/my.cnf)
- Character set: utf8mb4
- Buffer pool: 256MB
- Max packet: 64MB

#### Nginx (docker/nginx/default.conf)
- Root: `/var/www/public`
- PHP-FPM via FastCGI
- Gzip compression
- Cache statico per asset

## 🚀 Workflow Completo

### Setup Iniziale (una volta sola)

```bash
# Metodo 1: Script automatico
./setup.sh

# Metodo 2: Manuale
cp .env.docker .env
docker-compose build
docker-compose up -d
docker-compose exec app php artisan key:generate
docker-compose exec app php artisan migrate
```

### Sviluppo Quotidiano

```bash
# Avvia
docker-compose up -d

# Modifica il codice normalmente
# I file sono montati come volume, le modifiche sono immediate

# Ferma quando hai finito
docker-compose down
```

### Deploy/Condivisione

```bash
# Opzione 1: Condividi tutto il progetto
# Zippa la cartella e invia

# Opzione 2: Git (consigliato)
git add .
git commit -m "Added Docker configuration"
git push

# Opzione 3: Solo l'immagine Docker
docker save -o app.tar laravel-filament-app
# Invia app.tar
```

## 📊 Gestione Dati

### Persistenza
- **Database**: Volume `mysql-data` (persiste anche dopo `down`)
- **Codice**: Montato come volume (modifiche live)
- **Storage Laravel**: Montato come volume

### Backup Database

```bash
# Export
docker-compose exec mysql mysqldump -u laravel -ppassword laravel > backup.sql

# Import
docker-compose exec -T mysql mysql -u laravel -ppassword laravel < backup.sql
```

## 🎯 Comandi Principali

### Con Make (più semplice)

```bash
make help          # Tutti i comandi disponibili
make install       # Setup iniziale completo
make up            # Avvia
make down          # Ferma
make logs          # Vedi log
make shell         # Entra nel container
make artisan       # Comando artisan (make artisan CMD="migrate")
make migrate       # Migrazioni
make filament-user # Crea utente admin
make fresh         # Reset completo
```

### Con Docker Compose

```bash
docker-compose up -d                              # Avvia
docker-compose down                               # Ferma
docker-compose logs -f                            # Log
docker-compose exec app bash                      # Shell
docker-compose exec app php artisan [comando]     # Artisan
docker-compose exec app composer [comando]        # Composer
docker-compose exec app npm [comando]             # NPM
```

## 🔍 Monitoring e Debug

### Log disponibili

```bash
# Log applicazione
docker-compose logs -f app

# Log MySQL
docker-compose logs -f mysql

# Log Laravel
docker-compose exec app tail -f storage/logs/laravel.log

# Log Queue Worker
docker-compose exec app tail -f storage/logs/worker.log
```

### Accesso ai container

```bash
# Bash nell'app
docker-compose exec app bash

# MySQL client
docker-compose exec mysql mysql -u laravel -ppassword laravel

# Vedi processi in esecuzione
docker-compose exec app ps aux
```

## ⚠️ Troubleshooting

### Problema: Porta già in uso
**Soluzione**: Cambia porta in `docker-compose.yml`

### Problema: Permessi
**Soluzione**: 
```bash
docker-compose exec app chown -R laravel:laravel storage bootstrap/cache
docker-compose exec app chmod -R 775 storage bootstrap/cache
```

### Problema: MySQL non si connette
**Soluzione**: 
- Verifica `.env` abbia `DB_HOST=mysql`
- Aspetta 10 secondi dopo `docker-compose up`

### Problema: Asset non compilati
**Soluzione**:
```bash
docker-compose exec app npm run build
```

## 📝 Checklist Pre-Condivisione

Prima di condividere con il tuo amico:

- [ ] Tutto funziona in locale
- [ ] File `.env` non committato (è in `.gitignore`)
- [ ] README-DOCKER.md incluso
- [ ] QUICK-START.md incluso
- [ ] File `.env.docker` incluso come template
- [ ] Tutti i file in `docker/` inclusi
- [ ] Testato `docker-compose build` da zero
- [ ] Testato `docker-compose up -d` funzioni

## 🎁 File da Condividere

### File essenziali
- ✅ Dockerfile
- ✅ docker-compose.yml
- ✅ .dockerignore
- ✅ .env.docker (template)
- ✅ docker/ (intera cartella)
- ✅ README-DOCKER.md
- ✅ QUICK-START.md

### File opzionali ma utili
- ⭐ Makefile
- ⭐ setup.sh

### File da NON condividere
- ❌ .env (contiene dati sensibili!)
- ❌ vendor/ (si rigenera)
- ❌ node_modules/ (si rigenera)
- ❌ storage/logs/*.log
- ❌ .git/ (se usi Git, push al repository)

## 🌟 Vantaggi di questa Setup

1. **Portabilità**: Funziona ovunque ci sia Docker
2. **Isolamento**: Non inquina il sistema host
3. **Consistenza**: Stesso ambiente per tutti
4. **Semplicità**: Un solo comando per avviare tutto
5. **Produzione-ready**: Stessa config in dev e prod
6. **Reversibilità**: `docker-compose down` pulisce tutto

## 📚 Risorse Utili

- Docker Docs: https://docs.docker.com
- Laravel Docs: https://laravel.com/docs
- Filament Docs: https://filamentphp.com/docs
- Docker Compose: https://docs.docker.com/compose

---

**Creato per**: Applicazione Laravel 12 + Filament 5
**PHP**: 8.2
**Database**: MySQL 8.4
**Server**: Nginx + PHP-FPM
**Assets**: Vite + Tailwind CSS 4
