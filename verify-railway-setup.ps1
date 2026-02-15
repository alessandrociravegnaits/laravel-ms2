# Script di verifica configurazione Railway per PHP 8.2
# PowerShell Version

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "🔍 VERIFICA CONFIGURAZIONE RAILWAY - PHP 8.2" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

# Verifica file .php-version
Write-Host "✓ Verifica .php-version..." -ForegroundColor Yellow
if (Test-Path ".php-version") {
    $version = Get-Content ".php-version"
    Write-Host "  ✅ File .php-version esistente: $version" -ForegroundColor Green
} else {
    Write-Host "  ❌ File .php-version non trovato!" -ForegroundColor Red
    exit 1
}

# Verifica Procfile
Write-Host ""
Write-Host "✓ Verifica Procfile..." -ForegroundColor Yellow
if (Test-Path "Procfile") {
    Write-Host "  ✅ Procfile esistente" -ForegroundColor Green
    Write-Host "  Contenuto:"
    Get-Content "Procfile" | ForEach-Object { Write-Host "    $_" }
} else {
    Write-Host "  ❌ Procfile non trovato!" -ForegroundColor Red
    exit 1
}

# Verifica nixpacks.toml
Write-Host ""
Write-Host "✓ Verifica nixpacks.toml..." -ForegroundColor Yellow
if (Test-Path "nixpacks.toml") {
    Write-Host "  ✅ nixpacks.toml esistente" -ForegroundColor Green
} else {
    Write-Host "  ❌ nixpacks.toml non trovato!" -ForegroundColor Red
    exit 1
}

# Verifica composer.json - PHP version
Write-Host ""
Write-Host "✓ Verifica versione PHP in composer.json..." -ForegroundColor Yellow
$composerContent = Get-Content "composer.json" -Raw
if ($composerContent -match '"php":\s*"\^8\.2"') {
    Write-Host "  ✅ PHP 8.2 configurato in composer.json" -ForegroundColor Green
} else {
    Write-Host "  ❌ PHP 8.2 non trovato in composer.json!" -ForegroundColor Red
    exit 1
}

# Verifica .env.example
Write-Host ""
Write-Host "✓ Verifica .env.example aggiornato..." -ForegroundColor Yellow
$envContent = Get-Content ".env.example" -Raw
if ($envContent -match 'MYSQLHOST') {
    Write-Host "  ✅ .env.example configurato per Railway" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  .env.example potrebbe necessitare aggiornamenti Railway" -ForegroundColor Yellow
}

# Lista estensioni PHP necessarie
Write-Host ""
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "📦 ESTENSIONI PHP CONFIGURATE IN NIXPACKS:" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "  • php82"
Write-Host "  • pdo, pdo_mysql"
Write-Host "  • mbstring, xml, zip"
Write-Host "  • bcmath, gd"
Write-Host "  • curl, fileinfo, tokenizer"
Write-Host ""

# Comandi Git suggeriti
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "📝 COMANDI PER COMMIT E PUSH:" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host 'git add .' -ForegroundColor White
Write-Host 'git commit -m "Configure Laravel project for Railway with PHP 8.2 and MySQL"' -ForegroundColor White
Write-Host 'git push origin main' -ForegroundColor White
Write-Host ""

# Variabili d'ambiente necessarie
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "🔐 VARIABILI D'AMBIENTE DA CONFIGURARE SU RAILWAY:" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "APP_NAME=eCommerce" -ForegroundColor White
Write-Host "APP_ENV=production" -ForegroundColor White
Write-Host "APP_KEY=base64:GENERA_CON_php_artisan_key:generate_--show" -ForegroundColor Yellow
Write-Host "APP_DEBUG=false" -ForegroundColor White
Write-Host "APP_URL=https://your-app.up.railway.app" -ForegroundColor Yellow
Write-Host ""
Write-Host "APP_LOCALE=it" -ForegroundColor White
Write-Host "APP_FALLBACK_LOCALE=en" -ForegroundColor White
Write-Host ""
Write-Host "LOG_LEVEL=info" -ForegroundColor White
Write-Host ""
Write-Host "# Database - Railway fornisce automaticamente:" -ForegroundColor Gray
Write-Host "# MYSQLHOST, MYSQLPORT, MYSQLDATABASE, MYSQLUSER, MYSQLPASSWORD" -ForegroundColor Gray
Write-Host ""
Write-Host "SESSION_DRIVER=database" -ForegroundColor White
Write-Host "FILESYSTEM_DISK=public" -ForegroundColor White
Write-Host "QUEUE_CONNECTION=database" -ForegroundColor White
Write-Host "CACHE_STORE=database" -ForegroundColor White
Write-Host ""

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "✅ CONFIGURAZIONE COMPLETATA!" -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📚 Leggi README-RAILWAY.md per istruzioni dettagliate" -ForegroundColor Yellow
Write-Host "📋 Consulta RAILWAY-SETUP-COMPLETE.md per il riepilogo" -ForegroundColor Yellow
Write-Host ""

