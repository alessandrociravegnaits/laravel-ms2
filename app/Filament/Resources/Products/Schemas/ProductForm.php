<?php

namespace App\Filament\Resources\Products\Schemas;

use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Textarea;
use Filament\Schemas\Schema;

class ProductForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('name')
                    ->required()
                    ->unique(ignoreRecord: true)
                    ->label('Nome prodotto'),
                Select::make('categories')
                    ->relationship('categories', 'name') // Nome funzione nel Modello e colonna da mostrare
                    ->multiple()   // Permette di scegliere più categorie (Pivot)
                    ->preload()    // Carica la lista all'apertura (ottimo per poche categorie)
                    ->searchable() // Permette di cercare se ne hai tante
                    ->required()
                    ->label('Categorie'),
                FileUpload::make('image')
                    ->image() // Dice a Filament che vogliamo solo foto
                    ->directory('products') // Crea una cartella pulita per i prodotti
                    ->imageEditor(), // (Opzionale) Ti permette di ritagliare la foto dopo l'upload!
                Textarea::make('description')
                    ->columnSpanFull()
                    ->label('Descrizione'),
                TextInput::make('price')
                    ->required()
                    ->numeric()
                    ->prefix('$')
                    ->label('Prezzo'),
            ]);
    }
}
