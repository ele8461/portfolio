<?php
die('carbonfields geladen');
use Carbon_Fields\Container;
use Carbon_Fields\Field;

Container::make('post_meta', 'Projekt')
    ->where('post_type', '=', 'project')
    ->add_fields([
        Field::make('text', 'project-id', 'Projekt-Nummer')
            ->set_attribute('type', 'number')
            ->set_required(true),
        Field::make('date', 'date', 'Datum')
            ->set_required(true),
        Field::make('image', 'thumbnail', 'Thumbnail')
            ->set_required(true),
        Field::make('oembed', 'project-upload', 'Media'),
        Field::make('text', 'duration', 'Länge'),
        Field::make('rich_text', 'lead', 'Beschreibung')
            ->set_required(true),
        Field::make('rich_text', 'credits', 'Credits'),
        Field::make('media_gallery', 'images', 'Bilder')
            ->set_type(['image']),
    ]);
