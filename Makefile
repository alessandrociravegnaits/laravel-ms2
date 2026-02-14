.PHONY: help build up down restart logs shell mysql artisan composer npm clean

# Colori per output
GREEN  := \033[0;32m
YELLOW := \033[0;33m
NC     := \033[0m # No Color

help: ## Mostra questo messaggio di aiuto
	@echo "$(GREEN)Comandi disponibili:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'

build: ## Build dei container Docker
	@echo "$(GREEN)Building containers...$(NC)"
	docker-compose build

up: ## Avvia i container in background
	@echo "$(GREEN)Starting containers...$(NC)"
	docker-compose up -d
	@echo "$(GREEN)Applicazione disponibile su http://localhost:8000$(NC)"

down: ## Ferma e rimuove i container
	@echo "$(YELLOW)Stopping containers...$(NC)"
	docker-compose down

restart: ## Riavvia i container
	@echo "$(YELLOW)Restarting containers...$(NC)"
	docker-compose restart

logs: ## Mostra i log di tutti i servizi
	docker-compose logs -f

logs-app: ## Mostra solo i log dell'applicazione
	docker-compose logs -f app

logs-mysql: ## Mostra solo i log di MySQL
	docker-compose logs -f mysql

shell: ## Accedi al container dell'app (bash)
	docker-compose exec app bash

mysql: ## Accedi al client MySQL
	docker-compose exec mysql mysql -u laravel -ppassword laravel

artisan: ## Esegui comando artisan (es: make artisan CMD="migrate")
	docker-compose exec app php artisan $(CMD)

composer: ## Esegui comando composer (es: make composer CMD="install")
	docker-compose exec app composer $(CMD)

npm: ## Esegui comando npm (es: make npm CMD="run dev")
	docker-compose exec app npm $(CMD)

migrate: ## Esegui le migrazioni del database
	@echo "$(GREEN)Running migrations...$(NC)"
	docker-compose exec app php artisan migrate

migrate-fresh: ## Ricrea il database da zero (ATTENZIONE: cancella tutti i dati!)
	@echo "$(YELLOW)This will delete all data! Press Ctrl+C to cancel...$(NC)"
	@sleep 3
	docker-compose exec app php artisan migrate:fresh --seed

filament-user: ## Crea un nuovo utente Filament admin
	docker-compose exec app php artisan make:filament-user

cache-clear: ## Pulisce tutte le cache
	@echo "$(GREEN)Clearing caches...$(NC)"
	docker-compose exec app php artisan cache:clear
	docker-compose exec app php artisan config:clear
	docker-compose exec app php artisan view:clear
	docker-compose exec app php artisan route:clear

optimize: ## Ottimizza l'applicazione
	@echo "$(GREEN)Optimizing application...$(NC)"
	docker-compose exec app php artisan optimize
	docker-compose exec app php artisan config:cache
	docker-compose exec app php artisan route:cache
	docker-compose exec app php artisan view:cache

fresh: down ## Reset completo (elimina tutto e ricrea)
	@echo "$(YELLOW)This will delete all containers and volumes! Press Ctrl+C to cancel...$(NC)"
	@sleep 3
	docker-compose down -v
	docker-compose build --no-cache
	docker-compose up -d
	@echo "$(GREEN)Fresh installation complete!$(NC)"

install: ## Setup iniziale completo
	@echo "$(GREEN)Setting up the application...$(NC)"
	@if [ ! -f .env ]; then cp .env.docker .env; echo "Created .env file"; fi
	docker-compose build
	docker-compose up -d
	@echo "Waiting for MySQL to be ready..."
	@sleep 10
	docker-compose exec app php artisan key:generate
	docker-compose exec app php artisan migrate
	@echo "$(GREEN)Installation complete! Visit http://localhost:8000$(NC)"

status: ## Mostra lo stato dei container
	docker-compose ps

clean: ## Rimuovi container, volumi e immagini inutilizzate
	@echo "$(YELLOW)Cleaning up...$(NC)"
	docker-compose down -v
	docker system prune -f
	@echo "$(GREEN)Cleanup complete!$(NC)"
