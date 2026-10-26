<?php

// todo: Hier die Getter für die Globalen Informationen definieren
function get_globals_socials() {
    $socials = carbon_get_theme_option('socials');
    return array_map( callback: function($item) {
    $item['title'] = get_media_by_id( id: $item['title']);
    return $item;
    }, array: $socials);
}