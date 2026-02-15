# 🚀 COMANDI DA ESEGUIRE PER DEPLOYMENT RAILWAY

## ✅ STATO ATTUALE
Tutti i file sono stati modificati e aggiunti al staging di Git.

## 📝 COMANDI DA ESEGUIRE (Copia e incolla nel terminale)

### 1. Commit delle Modifiche
```bash
git commit -m "Configure Laravel for Railway deployment with PHP 8.2 and MySQL

- Add .php-version file for PHP 8.2
- Add Procfile for web server and queue worker
- Add nixpacks.toml with PHP 8.2 extensions configuration
- Update .env.example with Railway MySQL variables
- Add composer.json post-install script for storage:link
- Add comprehensive Railway deployment documentation
- Add verification scripts for Railway setup"
```

### 2. Push su Repository
```bash
git push origin main
```

### 3. Genera APP_KEY (Necessario per Railway)
```bash
php artisan key:generate --show
```
**Salva l'output** (es: `base64:abc123...`) - lo userai come variabile d'ambiente su Railway.

---

## 🌐 SETUP RAILWAY (Da fare su railway.app)

### Passo 1: Crea Progetto
1. Vai su https://railway.app
2. Login/Signup
3. Click **"New Project"**
4. Seleziona **"Deploy from GitHub repo"**
5. Autorizza Railway → Seleziona repository `laravel-ms2`

### Passo 2: Aggiungi MySQL Database
1. Nel dashboard del progetto, click **"+ New"**
2. Seleziona **"Database"**
3. Scegli **"Add MySQL"**
4. Railway creerà automaticamente:
   - MYSQLHOST
   - MYSQLPORT
   - MYSQLDATABASE
   - MYSQLUSER
   - MYSQLPASSWORD

### Passo 3: Configura Variabili d'Ambiente
1. Click sul servizio Laravel (non MySQL)
2. Vai su tab **"Variables"**
3. Aggiungi queste variabili (click **"+ New Variable"** per ognuna):

```
APP_NAME=eCommerce
APP_ENV=production
APP_KEY=base64:INCOLLA_QUI_IL_KEY_GENERATO_AL_PASSO_3
APP_DEBUG=false
APP_URL=https://laravel-ms2-production.up.railway.app
APP_LOCALE=it
APP_FALLBACK_LOCALE=en
LOG_LEVEL=info
SESSION_DRIVER=database
FILESYSTEM_DISK=public
QUEUE_CONNECTION=database
CACHE_STORE=database
```

**Nota**: Sostituisci `APP_KEY` con il valore generato al passo 3 sopra!

### Passo 4: Genera Dominio
1. Nel servizio Laravel, vai su **"Settings"**
2. Scorri a **"Networking"** → **"Public Networking"**
3. Click **"Generate Domain"**
4. Copia il dominio generato (es: `laravel-ms2-production.up.railway.app`)
5. Torna su **"Variables"** e aggiorna `APP_URL` con il dominio copiato

### Passo 5: Deploy!
Railway deploierà automaticamente. Monitora il deploy:
1. Click su **"Deployments"** (nella barra laterale)
2. Guarda i logs in tempo reale
3. Cerca messaggi di successo:
   - `✓ Composer install completed`
   - `✓ npm build completed`
   - `✓ Migrations executed`
   - `✓ Server started on port XXXX`

---

## 👤 CREA UTENTE ADMIN (Dopo il deploy)

### Opzione A: Usando Railway CLI (Raccomandato)
```bash
# Installa Railway CLI
npm install -g @railway/cli

# Login
railway login

# Collega al progetto (esegui nella cartella del progetto)
railway link

# Apri tinker
railway run php artisan tinker
```

Nel prompt di Tinker, digita:
```php
\App\Models\User::create([
    'name' => 'Admin',
    'email' => 'admin@example.com',
    'password' => bcrypt('La_Tua_Password_Sicura')
]);
exit
```

### Opzione B: Usando Railway Console
1. Nel dashboard Railway, click sul servizio Laravel
2. Tab **"Deployments"** → Seleziona ultimo deploy
3. Click **⋮** (tre puntini) → **"View Console"**
4. Esegui:
```bash
php artisan tinker
```
Poi il comando di creazione utente sopra.

---

## 🔐 ACCEDI AL PANEL ADMIN

Apri nel browser:
```
https://TUO-DOMINIO-RAILWAY.up.railway.app/admin
```

Login con:
- **Email**: `admin@example.com`
- **Password**: La password che hai impostato

---

## 📦 CONFIGURAZIONE STORAGE (IMPORTANTE!)

Railway NON ha storage persistente di default. Le immagini caricate verranno perse ad ogni redeploy.

### Soluzione Rapida: Railway Volumes
1. Nel progetto, click **"+ New"** → **"Volume"**
2. Nome: `storage-volume`
3. Mount path: `/app/storage/app/public`
4. Salva

### Soluzione Produzione: AWS S3
```bash
# Aggiungi pacchetto
composer require league/flysystem-aws-s3-v3

# Commit e push
git add composer.json composer.lock
git commit -m "Add S3 storage support"
git push origin main
```

Poi aggiungi su Railway:
```
FILESYSTEM_DISK=s3
AWS_ACCESS_KEY_ID=tua-key
AWS_SECRET_ACCESS_KEY=tuo-secret
AWS_DEFAULT_REGION=eu-central-1
AWS_BUCKET=tuo-bucket-name
AWS_URL=https://tuo-bucket.s3.eu-central-1.amazonaws.com
```

---

## ✅ CHECKLIST COMPLETA

- [ ] ✅ Modifiche committate localmente
- [ ] ✅ Push su GitHub/GitLab
- [ ] ⬜ Progetto Railway creato
- [ ] ⬜ Database MySQL aggiunto
- [ ] ⬜ Variabili d'ambiente configurate
- [ ] ⬜ APP_KEY generato e impostato
- [ ] ⬜ Dominio generato e APP_URL aggiornato
- [ ] ⬜ Deploy completato con successo
- [ ] ⬜ Utente admin creato
- [ ] ⬜ Login admin funzionante
- [ ] ⬜ Storage configurato (Volume o S3)

---

## 🆘 TROUBLESHOOTING

### Deploy fallisce
```bash
# Controlla logs su Railway dashboard
# Verifica che tutti i file siano stati pushati
git push origin main --force
```

### "No application encryption key"
- Verifica che `APP_KEY` sia impostato correttamente nelle variabili Railway
- Deve iniziare con `base64:`

### Errore database
- Verifica che il servizio MySQL sia avviato
- Controlla che le variabili MYSQL* siano disponibili nel servizio Laravel

### Assets non caricati
```bash
# Su Railway CLI
railway run php artisan optimize:clear
railway run npm run build
```

---

## 📚 DOCUMENTAZIONE COMPLETA

Consulta per maggiori dettagli:
- **README-RAILWAY.md** - Guida completa
- **RAILWAY-SETUP-COMPLETE.md** - Riepilogo tecnico

---

## 🎉 HAI FINITO!

Il tuo progetto Laravel + Filament con PHP 8.2 e MySQL è deployato su Railway! 🚀

