# 🚀 QUICK START - Deploy su Railway

## ✅ SETUP COMPLETATO
Il progetto è configurato per PHP 8.2 e MySQL su Railway.

---

## 📝 COMANDI DA ESEGUIRE ORA

### 1. Commit
```bash
git commit -m "Configure Laravel for Railway deployment with PHP 8.2 and MySQL"
```

### 2. Push
```bash
git push origin main
```

### 3. Genera APP_KEY (salva output)
```bash
php artisan key:generate --show
```
**Copia il valore generato** (es: `base64:abc123...`)

---

## 🌐 SU RAILWAY.APP

### A. Crea Progetto
1. https://railway.app → **New Project**
2. **Deploy from GitHub repo** → Seleziona `laravel-ms2`

### B. Aggiungi MySQL
1. Click **+ New** → **Database** → **MySQL**

### C. Configura Variabili (servizio Laravel, tab Variables)
```env
APP_NAME=eCommerce
APP_ENV=production
APP_KEY=base64:INCOLLA_QUI_KEY_GENERATA
APP_DEBUG=false
APP_URL=https://TUO-DOMINIO.up.railway.app
APP_LOCALE=it
LOG_LEVEL=info
SESSION_DRIVER=database
FILESYSTEM_DISK=public
QUEUE_CONNECTION=database
CACHE_STORE=database
```

### D. Genera Dominio
1. Settings → Networking → **Generate Domain**
2. Copia dominio → Aggiorna `APP_URL` nelle variabili

### E. Deploy Automatico
Railway deploierà automaticamente. Monitora i logs.

---

## 👤 CREA ADMIN (dopo deploy)

### Installa Railway CLI
```bash
npm install -g @railway/cli
railway login
railway link
```

### Crea Utente
```bash
railway run php artisan tinker
```

In tinker:
```php
\App\Models\User::create(['name' => 'Admin', 'email' => 'admin@example.com', 'password' => bcrypt('password')]);
exit
```

**Login**: `https://tuo-dominio.up.railway.app/admin`

---

## 📦 STORAGE (Importante!)

Railway non ha storage persistente. Aggiungi Volume:

1. **+ New** → **Volume**
2. Nome: `storage-volume`
3. Mount: `/app/storage/app/public`

---

## ✅ FATTO!
Leggi **ISTRUZIONI-DEPLOYMENT.md** per dettagli completi.

