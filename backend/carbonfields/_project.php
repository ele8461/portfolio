<?php
use Carbon_Fields\Container;
use Carbon_Fields\Field;

Container::make('post_meta', 'Projekt')
    ->where('post_type', '=', 'project')
    ->add_fields([
        Field::make('text', 'project-id', 'Projekt-Nummer')
            ->set_attribute('type', 'number')
            ->set_required(true),
        //Media
        Field::make('select', 'media_type', 'Media-Art')
            ->add_options([
                'none'  => 'Kein Media',
                'link'  => 'Link (YouTube, Vimeo, ...)',
                'video' => 'Video hochladen',
                'audio' => 'Audio hochladen',
                'image' => 'Bild hochladen',
            ]),
        Field::make('oembed', 'media_link', 'Media-Link')
            ->set_conditional_logic([['field' => 'media_type', 'value' => 'link']]),
        Field::make('file', 'media_video', 'Video')
            ->set_type(['video'])
            ->set_value_type('id')
            ->set_conditional_logic([['field' => 'media_type', 'value' => 'video']]),
        Field::make('file', 'media_audio', 'Audio')
            ->set_type(['audio'])
            ->set_value_type('id')
            ->set_conditional_logic([['field' => 'media_type', 'value' => 'audio']]),
        Field::make('image', 'media_image', 'Bild')
            ->set_conditional_logic([['field' => 'media_type', 'value' => 'image']]),
        //End Media

        Field::make('image', 'thumbnail', 'Thumbnail')
            ->set_required(true),
        Field::make('text', 'duration', 'Länge'),
        Field::make('date', 'date', 'Datum')
            ->set_required(true),
        Field::make('rich_text', 'lead', 'Beschreibung')
             ->set_required(true),
        Field::make('rich_text', 'credits', 'Credits'),
        Field::make('media_gallery', 'images', 'Bilder')
            ->set_type(['image']),
    ]);