# Guida Deployment su Railway

Questa guida ti aiuterà a deployare l'applicazione Laravel + Filament su Railway.

## 📋 Prerequisiti

- Account Railway ([Registrati qui](https://railway.app))
- Git installato sul tuo computer
- Repository Git del progetto (GitHub, GitLab, o Bitbucket)

## 🚀 Configurazione Progetto

### 1. File di Configurazione Railway

Il progetto include già i seguenti file per Railway:

- **`.php-version`**: Specifica PHP 8.2
- **`Procfile`**: Definisce i processi web e worker
- **`nixpacks.toml`**: Configurazione build con estensioni PHP necessarie
- **`.env.example`**: Template variabili d'ambiente per Railway

## 🔧 Setup su Railway

### 1. Crea Nuovo Progetto

1. Vai su [railway.app](https://railway.app)
2. Clicca su **"New Project"**
3. Seleziona **"Deploy from GitHub repo"**
4. Autorizza Railway ad accedere al tuo repository
5. Seleziona il repository `laravel-ms2`

### 2. Aggiungi Database MySQL

1. Nel progetto Railway, clicca su **"+ New"**
2. Seleziona **"Database"**
3. Scegli **"Add MySQL"**
4. Railway creerà automaticamente il database e le variabili d'ambiente

### 3. Configura Variabili d'Ambiente

Railway ha già le variabili MySQL automatiche. Aggiungi le seguenti variabili al servizio web:

```env
APP_NAME=eCommerce
APP_ENV=production
APP_KEY=base64:YOUR_APP_KEY_HERE
APP_DEBUG=false
APP_URL=https://your-app.up.railway.app

APP_LOCALE=it
APP_FALLBACK_LOCALE=en

LOG_LEVEL=info

# Session e Cache
SESSION_DRIVER=database
FILESYSTEM_DISK=public
QUEUE_CONNECTION=database
CACHE_STORE=database
```

### 4. Genera APP_KEY

Per generare `APP_KEY`:

```bash
# Locale
php artisan key:generate --show

# Oppure online: https://generate-random.org/laravel-key-generator
```

Copia il valore generato (es: `base64:abc123...`) e impostalo come variabile `APP_KEY` su Railway.

### 5. Configurazione Domini

1. Nel servizio web, vai su **"Settings"**
2. Nella sezione **"Domains"**, clicca **"Generate Domain"**
3. Copia il dominio generato (es: `your-app.up.railway.app`)
4. Aggiorna la variabile `APP_URL` con questo dominio

## 🎯 Deploy

### Deploy Automatico

Railway deployerà automaticamente ad ogni push su GitHub:

```bash
git add .
git commit -m "Configure for Railway deployment"
git push origin main
```

### Verifica Deploy

1. Vai alla sezione **"Deployments"** su Railway
2. Monitora i log di build
3. Una volta completato, clicca sul dominio per aprire l'app

### Primo Avvio - Migrazioni Database

Le migrazioni vengono eseguite automaticamente nel `nixpacks.toml`, ma se necessario puoi eseguirle manualmente:

1. Vai su **"Deployments"** → seleziona l'ultimo deploy
2. Clicca sui **3 puntini** → **"View Logs"**
3. Verifica che le migrazioni siano state eseguite

Oppure usa il terminale Railway:

1. Installa Railway CLI: `npm i -g @railway/cli`
2. Login: `railway login`
3. Link al progetto: `railway link`
4. Esegui comando: `railway run php artisan migrate --force`

## 🔐 Accesso Admin Filament

Crea un utente admin:

```bash
# Da Railway CLI
railway run php artisan tinker

# Nel prompt PHP:
\App\Models\User::create([
    'name' => 'Admin',
    'email' => 'admin@example.com',
    'password' => bcrypt('password'),
]);
```

Accedi su: `https://your-app.up.railway.app/admin`

## 📦 Storage File (Immagini Prodotti)

**Nota Importante**: Railway non ha storage persistente di default. I file caricati verranno persi ad ogni redeploy.

### Soluzioni per Storage Persistente:

#### Opzione 1: Railway Volumes (Raccomandato)

1. Nel progetto Railway, clicca **"+ New"** → **"Volume"**
2. Nomina il volume: `storage-volume`
3. Monta il volume al percorso: `/app/storage/app/public`

#### Opzione 2: AWS S3 (Produzione)

Aggiungi al `composer.json`:
```bash
composer require league/flysystem-aws-s3-v3
```

Configura variabili su Railway:
```env
FILESYSTEM_DISK=s3
AWS_ACCESS_KEY_ID=your-key
AWS_SECRET_ACCESS_KEY=your-secret
AWS_DEFAULT_REGION=eu-central-1
AWS_BUCKET=your-bucket-name
```

## 🔄 Queue Worker

Il `Procfile` include già un worker per le code. Per attivarlo:

1. Nel servizio web, vai su **"Settings"**
2. Scorri fino a **"Service"**
3. In **"Start Command"**, modifica con:
   ```
   web: php artisan serve --host=0.0.0.0 --port=$PORT
   ```
4. Crea un **nuovo servizio** per il worker:
   - Clicca **"+ New"** → **"GitHub Repo"** → stesso repo
   - Nelle impostazioni, cambia **"Start Command"** in:
     ```
     php artisan queue:work --tries=3 --timeout=90
     ```

## 🐛 Troubleshooting

### Errore "No application encryption key"
- Imposta correttamente `APP_KEY` nelle variabili d'ambiente

### Errore Database Connection
- Verifica che il servizio MySQL sia attivo
- Le variabili `MYSQLHOST`, `MYSQLPORT`, ecc. devono essere disponibili automaticamente

### Assets non caricati (CSS/JS mancanti)
- Verifica che `npm run build` sia eseguito nel build
- Controlla i log di build per errori Vite

### Permessi Storage
```bash
railway run php artisan storage:link
```

## 📊 Monitoraggio

- **Logs**: Vai su Deployments → View Logs
- **Metriche**: Railway mostra CPU, RAM, Network usage
- **Database**: Accedi via Railway CLI o client MySQL esterno

## 🔄 Aggiornamenti

Per deployare nuove modifiche:

```bash
git add .
git commit -m "Your changes"
git push origin main
```

Railway deployer automaticamente.

## 💰 Costi

Railway offre:
- **$5 gratis/mese** (Hobby Plan)
- Dopo il limite gratuito: **$0.000463/GB-hour** per RAM e CPU

Stima per questa app: ~$10-15/mese in produzione leggera.

## 📚 Risorse Utili

- [Railway Docs](https://docs.railway.app/)
- [Laravel Deployment](https://laravel.com/docs/deployment)
- [Filament Docs](https://filamentphp.com/docs)

---

**✅ Setup completato!** La tua applicazione Laravel + Filament è pronta per Railway con PHP 8.2 e MySQL.

