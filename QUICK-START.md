# 🚀 Quick Start - Avvio Rapido

Guida per far partire velocemente l'applicazione Laravel + Filament.

## 1️⃣ Installazione (una sola volta)

### Scarica Docker Desktop
- **Windows/Mac**: https://www.docker.com/products/docker-desktop
- Installa e avvia Docker Desktop

### Verifica installazione
Apri il terminale e digita:
```bash
docker --version
docker-compose --version
```

Se vedi le versioni, sei pronto! ✅

## 2️⃣ Avvio dell'app

### Metodo 1: Con Make (più semplice)

Se hai `make` installato:

```bash
# Setup iniziale (solo la prima volta)
make install

# Avvia l'app
make up

# Apri http://localhost:8000
```

### Metodo 2: Con Docker Compose

```bash
# Crea il file .env (solo la prima volta)
cp .env.docker .env

# Build dei container (solo la prima volta)
docker-compose build

# Avvia i container
docker-compose up -d

# Genera la chiave dell'app (solo la prima volta)
docker-compose exec app php artisan key:generate

# Esegui le migrazioni (solo la prima volta)
docker-compose exec app php artisan migrate

# Apri http://localhost:8000
```

## 3️⃣ Verifica che funzioni

Apri il browser su: **http://localhost:8000**

Dovresti vedere l'applicazione Laravel/Filament!

## 4️⃣ Creare un utente admin (opzionale)

Per accedere al pannello Filament:

```bash
# Con Make
make filament-user

# OPPURE con docker-compose
docker-compose exec app php artisan make:filament-user
```

Segui le istruzioni per inserire nome, email e password.

Poi vai su: **http://localhost:8000/admin**

## 📋 Comandi utili

```bash
# Vedere i log
make logs
# OPPURE
docker-compose logs -f

# Fermare l'app
make down
# OPPURE
docker-compose down

# Riavviare l'app
make restart
# OPPURE
docker-compose restart

# Vedere lo stato
make status
# OPPURE
docker-compose ps
```

## 🐛 Problemi comuni

### Porta 8000 già in uso

Modifica il file `docker-compose.yml`:
```yaml
ports:
  - "8080:80"  # Usa 8080 invece di 8000
```

Poi visita: http://localhost:8080

### L'app non si avvia

```bash
# Ferma tutto
docker-compose down

# Rebuilda da zero
docker-compose build --no-cache

# Riavvia
docker-compose up -d
```

### Errori di permessi

```bash
docker-compose exec app chmod -R 775 storage bootstrap/cache
docker-compose exec app chown -R laravel:laravel storage bootstrap/cache
```

## ✅ Checklist

- [ ] Docker Desktop installato e avviato
- [ ] File `.env` creato (copia da `.env.docker`)
- [ ] Eseguito `docker-compose build`
- [ ] Eseguito `docker-compose up -d`
- [ ] L'app risponde su http://localhost:8000
- [ ] Creato utente admin (se necessario)

## 📞 Hai bisogno di aiuto?

Leggi il file **README-DOCKER.md** per la guida completa!

## 🎉 Fatto!

L'app dovrebbe funzionare. Buon testing! 🚀
