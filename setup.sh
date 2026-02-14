#!/bin/bash

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Laravel + Filament Docker Setup         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

# Verifica che Docker sia installato
if ! command -v docker &> /dev/null; then
    echo -e "${RED}✗ Docker non è installato!${NC}"
    echo -e "${YELLOW}Scarica Docker Desktop da: https://www.docker.com/products/docker-desktop${NC}"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}✗ Docker Compose non è installato!${NC}"
    echo -e "${YELLOW}Scarica Docker Desktop da: https://www.docker.com/products/docker-desktop${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker è installato${NC}"

# Verifica che Docker sia in esecuzione
if ! docker info &> /dev/null; then
    echo -e "${RED}✗ Docker non è in esecuzione!${NC}"
    echo -e "${YELLOW}Avvia Docker Desktop e riprova.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker è in esecuzione${NC}"
echo ""

# Crea il file .env se non esiste
if [ ! -f .env ]; then
    echo -e "${YELLOW}→ Creazione file .env...${NC}"
    if [ -f .env.docker ]; then
        cp .env.docker .env
        echo -e "${GREEN}✓ File .env creato da .env.docker${NC}"
    elif [ -f .env.example ]; then
        cp .env.example .env
        echo -e "${GREEN}✓ File .env creato da .env.example${NC}"
        echo -e "${YELLOW}⚠ Ricorda di configurare le credenziali del database nel file .env${NC}"
    else
        echo -e "${RED}✗ Nessun file .env.docker o .env.example trovato!${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✓ File .env già esistente${NC}"
fi

echo ""
echo -e "${YELLOW}→ Build dei container Docker...${NC}"
echo -e "${BLUE}   (Questo potrebbe richiedere alcuni minuti la prima volta)${NC}"
docker-compose build

if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Errore durante il build dei container${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Build completato${NC}"
echo ""

echo -e "${YELLOW}→ Avvio dei container...${NC}"
docker-compose up -d

if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Errore durante l'avvio dei container${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Container avviati${NC}"
echo ""

echo -e "${YELLOW}→ Attesa che MySQL sia pronto...${NC}"
sleep 10

# Controlla se la chiave è già generata
if ! grep -q "APP_KEY=base64:" .env; then
    echo -e "${YELLOW}→ Generazione chiave applicazione...${NC}"
    docker-compose exec -T app php artisan key:generate
    echo -e "${GREEN}✓ Chiave generata${NC}"
else
    echo -e "${GREEN}✓ Chiave applicazione già presente${NC}"
fi

echo ""
echo -e "${YELLOW}→ Esecuzione migrazioni database...${NC}"
docker-compose exec -T app php artisan migrate --force

if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Errore durante le migrazioni${NC}"
    echo -e "${YELLOW}Verifica la configurazione del database nel file .env${NC}"
else
    echo -e "${GREEN}✓ Migrazioni completate${NC}"
fi

echo ""
echo -e "${GREEN}✓ Ottimizzazione applicazione...${NC}"
docker-compose exec -T app php artisan config:cache
docker-compose exec -T app php artisan route:cache
docker-compose exec -T app php artisan view:cache

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║            SETUP COMPLETATO! ✨            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}L'applicazione è disponibile su:${NC}"
echo -e "${YELLOW}   → http://localhost:8000${NC}"
echo ""
echo -e "${GREEN}Dashboard Filament (se configurato):${NC}"
echo -e "${YELLOW}   → http://localhost:8000/admin${NC}"
echo ""
echo -e "${BLUE}Comandi utili:${NC}"
echo -e "  ${YELLOW}docker-compose logs -f${NC}       Visualizza i log"
echo -e "  ${YELLOW}docker-compose down${NC}           Ferma i container"
echo -e "  ${YELLOW}docker-compose restart${NC}        Riavvia i container"
echo -e "  ${YELLOW}make help${NC}                     Vedi tutti i comandi (se hai Make)"
echo ""
echo -e "${GREEN}Per creare un utente admin Filament:${NC}"
echo -e "  ${YELLOW}docker-compose exec app php artisan make:filament-user${NC}"
echo ""
echo -e "${BLUE}Buon lavoro! 🚀${NC}"
