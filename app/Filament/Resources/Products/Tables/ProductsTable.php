<?php

namespace App\Filament\Resources\Products\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteAction;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\ImageColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class ProductsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                ImageColumn::make('image') ->label('Foto') ->circular(),
                TextColumn::make('name')
                    ->sortable()
                    ->searchable()
                    ->label('Nome prodotto'),
                TextColumn::make('price')
                    ->money()
                    ->sortable()
                    ->label('Prezzo'),
                TextColumn::make('categories.name') // <-- Modificato da 'category.name' a 'ca…
                ->label('Categories') // <-- Etichetta cambiata per riflettere il plurale
                ->listWithLineBreaks() // <-- Aggiunto per mostrare ogni categoria su una
                ->searchable() // <-- Resa ricercabile per nome categoria
                ->label('Categorie'),
                TextColumn::make('created_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
                TextColumn::make('updated_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                //
            ])
->recordActions([
    EditAction::make()->label(''),
    DeleteAction::make()->label(''),
])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
