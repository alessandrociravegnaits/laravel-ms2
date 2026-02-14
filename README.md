# Laravel eCommerce - Filament Admin Panel

Applicazione eCommerce sviluppata con Laravel 11 e Filament 3 per la gestione di prodotti e categorie.

## Caratteristiche

- **Admin Panel** con Filament 3
- **Gestione Prodotti** con relazioni many-to-many con categorie
- **Gestione Categorie** gerarchiche
- **Upload Immagini** per i prodotti
- **Autenticazione** utenti
- **Database** MySQL
- **Localizzazione** italiana

## Tecnologie Utilizzate


- **Laravel 11** - Framework PHP
- **Filament 3** - Admin Panel
- **MySQL** - Database
- **Livewire** - Componenti reattivi
- **Tailwind CSS** - Styling

## Requisiti

- PHP 8.2 o superiore
- Composer
- MySQL 8.0 o superiore
- Node.js e NPM

## Installazione

1. **Clona il repository**
   ```bash
   git clone <repository-url>
   cd laravel-ms2
   ```

2. **Installa le dipendenze PHP**
   ```bash
   composer install
   ```

3. **Installa le dipendenze JavaScript**
   ```bash
   npm install
   ```

4. **Copia il file di configurazione**
   ```bash
   cp .env.example .env
   ```

5. **Genera la chiave dell'applicazione**
   ```bash
   php artisan key:generate
   ```

6. **Configura il database nel file `.env`**
   ```
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=laravel-ms2_db
   DB_USERNAME=root
   DB_PASSWORD=
   ```

7. **Crea il database**
   ```bash
   mysql -u root -p -e "CREATE DATABASE laravel-ms2_db;"
   ```

8. **Esegui le migrazioni**
   ```bash
   php artisan migrate
   ```

9. **Crea un utente admin**
   ```bash
   php artisan make:filament-user
   ```

10. **Compila gli assets**
    ```bash
    npm run build
    ```

11. **Avvia il server di sviluppo**
    ```bash
    php artisan serve
    ```

12. **Accedi al pannello admin**
    - URL: `http://localhost:8000/admin`
    - Usa le credenziali create al punto 9

## Struttura del Progetto

```
app/
├── Filament/
│   └── Resources/       # Risorse Filament per gestione prodotti/categorie
├── Models/
│   ├── Product.php      # Model Prodotto
│   ├── Category.php     # Model Categoria
│   └── User.php         # Model Utente
database/
├── migrations/          # Migrazioni database
└── seeders/            # Seeder per dati iniziali
```

## Modelli

### Product (Prodotto)
- `name` - Nome prodotto
- `description` - Descrizione
- `price` - Prezzo
- `stock` - Quantità disponibile
- `image` - Immagine prodotto
- Relazione many-to-many con `Category`

### Category (Categoria)
- `name` - Nome categoria
- `description` - Descrizione
- `parent_id` - Categoria padre (per gerarchia)
- Relazione many-to-many con `Product`

## Deployment

### Railway (Consigliato)

1. Crea un account su [Railway](https://railway.app)
2. Collega il repository GitHub
3. Railway rileverà automaticamente Laravel e installerà le dipendenze
4. Aggiungi un database MySQL dal marketplace di Railway
5. Configura le variabili d'ambiente
6. Deploy automatico!

## Supporto Docker

Il progetto include file Docker per l'ambiente di sviluppo:
- `docker-compose.yml` - Configurazione generale
- `docker-compose-mysql.yml` - Configurazione MySQL
- `Dockerfile` - Immagine PHP/Laravel

Per usare Docker:
```bash
docker-compose up -d
```

## Licenza

Questo progetto è open-source sotto licenza MIT.

## Autore

Sviluppato con ❤️ usando Laravel e Filament

In order to ensure that the Laravel community is welcoming to all, please review and abide by the [Code of Conduct](https://laravel.com/docs/contributions#code-of-conduct).

## Security Vulnerabilities

If you discover a security vulnerability within Laravel, please send an e-mail to Taylor Otwell via [taylor@laravel.com](mailto:taylor@laravel.com). All security vulnerabilities will be promptly addressed.

## License

The Laravel framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
