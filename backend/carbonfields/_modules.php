<?php
use Carbon_Fields\Container;
use Carbon_Fields\Field;

// -> Konfiguration der verschiedenen Module
Container::make('post_meta', 'Module')
    ->where('post_type', '=', 'page')
    ->add_fields([
        Field::make('complex', 'modules', 'Module')
            ->set_layout('tabbed-vertical')
            // -> Selected Work (1-4 manuell gewählte Projekte)
            ->add_fields('selected_projects', 'Selected Work', [
                Field::make('text', 'title', 'Titel')->set_required(),
                Field::make('association', 'selection', 'Auswahl Projekte')
                    ->set_types([
                        [
                            'type'      => 'post',
                            'post_type' => 'project',
                        ],
                    ])
                    ->set_min(1)
                    ->set_max(4)
                    ->set_required(),
            ])
            // -> Work (alle Projekte, automatisch)
            ->add_fields('all_projects', 'Work', [
                Field::make('text', 'title', 'Titel')->set_required(),
            ])
            // -> About
            ->add_fields('about', 'About', [
                Field::make('text', 'title', 'Titel')->set_required(),
                Field::make('image', 'image1', 'Bild 1')->set_required(),
                Field::make('text', 'date1', 'Datum Bild 1')->set_required(),
                Field::make('image', 'image2', 'Bild 2')->set_required(),
                Field::make('date', 'date2', 'Datum Bild 2')->set_required(),
                Field::make('rich_text', 'bio', 'Beschreibung')->set_required(),
                Field::make('rich_text', 'credits', 'Kleiner Text'),
            ])
    ]);

// -> Funktion, um die Module und die entsprechenden Templates auf der Seite zu laden
function render_modules (): void {
    $modules = carbon_get_the_post_meta('modules');
    if (empty($modules)) {
        return;
    }
    foreach ($modules as $module) {
        // -> Modifiziere die Daten des Moduls, falls nötig, basierend auf dem Modultyp
        switch ($module['_type']) {
            case 'selected_projects':
                $ids = wp_list_pluck($module['selection'] ?? [], 'id');
                $module['projects'] = get_projects($ids);
                break;
            case 'all_projects':
                $module['projects'] = get_projects();
                $module['filters'] = get_main_categories();
                break;
            case 'about':
                $module['image1'] = get_media_by_id($module['image1'], 'full');
                $module['image2'] = get_media_by_id($module['image2'], 'full');
                break;
        }
        // -> Laden des Templates basierend auf dem Modultyp und weitergeben der Daten
        get_template_part(
            'frontend/views/modules/' . $module['_type'],
            null,
            [
                'data' => $module
            ]
        );
    }
}