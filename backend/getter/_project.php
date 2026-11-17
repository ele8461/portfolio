<?php
// -> Namen aller Terms einer Taxonomie
function get_term_names (int $id, string $taxonomy): array {
    $names = wp_get_post_terms($id, $taxonomy, ['fields' => 'names']);
    return is_wp_error($names) ? [] : $names;
}

// -> Media-Element der Projektseite (je nach gewählter Media-Art)
function get_project_media (int $id): ?array {
    $type = carbon_get_post_meta($id, 'media_type');
    $thumbnail_id = (int) carbon_get_post_meta($id, 'thumbnail');
    $poster = $thumbnail_id ? (string) wp_get_attachment_image_url($thumbnail_id, 'l') : '';

    switch ($type) {
        case 'link':
            $url = carbon_get_post_meta($id, 'media_link');
            $html = $url ? wp_oembed_get($url) : false;
            return $html ? ['type' => 'link', 'html' => $html] : null;

        case 'video':
            $file = (int) carbon_get_post_meta($id, 'media_video');
            $src = $file ? wp_get_attachment_url($file) : '';
            return $src ? ['type' => 'video', 'src' => $src, 'poster' => $poster] : null;

        case 'audio':
            $file = (int) carbon_get_post_meta($id, 'media_audio');
            $src = $file ? wp_get_attachment_url($file) : '';
            return $src ? ['type' => 'audio', 'src' => $src, 'poster' => $poster] : null;

        case 'image':
            $file = (int) carbon_get_post_meta($id, 'media_image');
            return $file ? ['type' => 'image', 'image' => get_media_by_id($file, 'l')] : null;
    }
    return null;
}

function get_project_by_id (int $id): array {
    $date = (string) carbon_get_post_meta($id, 'date');
    $gallery = carbon_get_post_meta($id, 'images');

    return [
        'title' => get_the_title($id),
        'subtitle' => carbon_get_post_meta($id, 'subtitle'),
        'media' => get_project_media($id),
        'project_categories' => get_term_names($id, 'project_category'),
        'genre_categories' => get_term_names($id, 'genre_category'),
        'duration' => carbon_get_post_meta($id, 'duration'),
        'year' => $date !== '' ? substr($date, 0, 4) : '',
        'lead' => carbon_get_post_meta($id, 'lead'),
        'credits' => carbon_get_post_meta($id, 'credits'),
        'images' => array_map(
            fn ($image_id) => get_media_by_id($image_id, 'm'),
            is_array($gallery) ? $gallery : []
        ),
    ];
}

// -> Leichte Variante fürs Thumbnail-Raster
function get_project_teaser (int $id): array {
    $thumbnail_id = carbon_get_post_meta($id, 'thumbnail');
    $date = (string) carbon_get_post_meta($id, 'date');
    $number = (int) carbon_get_post_meta($id, 'project-id');
    $types = wp_get_post_terms($id, 'project_category', ['fields' => 'names']);
    $categories = wp_get_post_terms($id, 'main_category', ['fields' => 'slugs']);
    $statuses = wp_get_post_terms($id, 'status_category', ['fields' => 'names']); // NEU

    return [
        'url' => get_permalink($id),
        'title' => get_the_title($id),
        'number' => str_pad((string) $number, 2, '0', STR_PAD_LEFT),
        'date' => str_replace('-', '/', $date),
        'type' => !is_wp_error($types) && !empty($types) ? $types[0] : '',
        'status' => !is_wp_error($statuses) && !empty($statuses) ? $statuses[0] : '', // NEU
        'main_categories' => is_wp_error($categories) ? [] : $categories,
        'thumbnail' => $thumbnail_id ? get_media_by_id($thumbnail_id, 'large') : null,
    ];
}

// -> Alle Projekte, sortiert nach Projekt-Nummer.
//    Optional: nur bestimmte IDs, in der im Backend gewählten Reihenfolge.
function get_projects (array $ids = []): array {
    $args = [
        'post_type' => 'project',
        'post_status' => 'publish',
        'posts_per_page' => -1,
        'fields' => 'ids',
    ];

    if (!empty($ids)) {
        // -> Ausgewählte Projekte: Reihenfolge der Auswahl beibehalten
        $args['post__in'] = $ids;
        $args['orderby'] = 'post__in';
    } else {
        // -> Alle Projekte: nach Projekt-Nummer
        $args['meta_key'] = '_project-id'; // Carbon Fields speichert mit Unterstrich-Präfix
        $args['orderby'] = 'meta_value_num';
        $args['order'] = 'ASC';
    }

    $query = new WP_Query($args);
    return array_map('get_project_teaser', $query->posts);
}

// -> Filter-Buttons (Taxonomie main_category)
function get_main_categories (): array {
    $terms = get_terms([
        'taxonomy' => 'main_category',
        'hide_empty' => true,
    ]);
    if (is_wp_error($terms)) {
        return [];
    }
    return array_map(fn ($term) => [
        'slug' => $term->slug,
        'name' => $term->name,
    ], $terms);
}