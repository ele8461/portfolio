<?php

// -> Socials (Titel + Link) aus den globalen Einstellungen
function get_globals_socials (): array {
    $socials = carbon_get_theme_option('socials');
    return is_array($socials) ? $socials : [];
}