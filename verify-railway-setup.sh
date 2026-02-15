#!/usr/bin/env bash
# Script di verifica configurazione Railway per PHP 8.2

echo "=============================================="
echo "🔍 VERIFICA CONFIGURAZIONE RAILWAY - PHP 8.2"
echo "=============================================="
echo ""

# Verifica file .php-version
echo "✓ Verifica .php-version..."
if [ -f ".php-version" ]; then
    VERSION=$(cat .php-version)
    echo "  ✅ File .php-version esistente: $VERSION"
else
    echo "  ❌ File .php-version non trovato!"
    exit 1
fi

# Verifica Procfile
echo ""
echo "✓ Verifica Procfile..."
if [ -f "Procfile" ]; then
    echo "  ✅ Procfile esistente"
    echo "  Contenuto:"
    cat Procfile | sed 's/^/    /'
else
    echo "  ❌ Procfile non trovato!"
    exit 1
fi

# Verifica nixpacks.toml
echo ""
echo "✓ Verifica nixpacks.toml..."
if [ -f "nixpacks.toml" ]; then
    echo "  ✅ nixpacks.toml esistente"
else
    echo "  ❌ nixpacks.toml non trovato!"
    exit 1
fi

# Verifica composer.json - PHP version
echo ""
echo "✓ Verifica versione PHP in composer.json..."
if grep -q '"php": "\^8.2"' composer.json; then
    echo "  ✅ PHP 8.2 configurato in composer.json"
else
    echo "  ❌ PHP 8.2 non trovato in composer.json!"
    exit 1
fi

# Verifica .env.example
echo ""
echo "✓ Verifica .env.example aggiornato..."
if grep -q 'MYSQLHOST' .env.example; then
    echo "  ✅ .env.example configurato per Railway"
else
    echo "  ⚠️  .env.example potrebbe necessitare aggiornamenti Railway"
fi

# Lista estensioni PHP necessarie
echo ""
echo "=============================================="
echo "📦 ESTENSIONI PHP CONFIGURATE IN NIXPACKS:"
echo "=============================================="
echo "  • php82"
echo "  • pdo, pdo_mysql"
echo "  • mbstring, xml, zip"
echo "  • bcmath, gd"
echo "  • curl, fileinfo, tokenizer"
echo ""

# Comandi Git suggeriti
echo "=============================================="
echo "📝 COMANDI PER COMMIT E PUSH:"
echo "=============================================="
echo 'git add .'
echo 'git commit -m "Configure Laravel project for Railway with PHP 8.2 and MySQL"'
echo 'git push origin main'
echo ""

# Variabili d'ambiente necessarie
echo "=============================================="
echo "🔐 VARIABILI D'AMBIENTE DA CONFIGURARE SU RAILWAY:"
echo "=============================================="
echo ""
echo "APP_NAME=eCommerce"
echo "APP_ENV=production"
echo "APP_KEY=base64:GENERA_CON_php_artisan_key:generate_--show"
echo "APP_DEBUG=false"
echo "APP_URL=https://your-app.up.railway.app"
echo ""
echo "APP_LOCALE=it"
echo "APP_FALLBACK_LOCALE=en"
echo ""
echo "LOG_LEVEL=info"
echo ""
echo "# Database - Railway fornisce automaticamente:"
echo "# MYSQLHOST, MYSQLPORT, MYSQLDATABASE, MYSQLUSER, MYSQLPASSWORD"
echo ""
echo "SESSION_DRIVER=database"
echo "FILESYSTEM_DISK=public"
echo "QUEUE_CONNECTION=database"
echo "CACHE_STORE=database"
echo ""

echo "=============================================="
echo "✅ CONFIGURAZIONE COMPLETATA!"
echo "=============================================="
echo ""
echo "📚 Leggi README-RAILWAY.md per istruzioni dettagliate"
echo "📋 Consulta RAILWAY-SETUP-COMPLETE.md per il riepilogo"
echo ""

