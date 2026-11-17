<?php
function get_project_by_id (int $id): array {
    return [
        'title' => get_the_title($id),
        'subtitle' => carbon_get_post_meta($id, 'subtitle'),
        'project-id' => carbon_get_post_meta($id, 'project-id'),
        'date' => carbon_get_post_meta($id, 'date'),
        'thumbnail' => carbon_get_post_meta($id, 'thumbnail'),
        'project-upload' => carbon_get_post_meta($id, 'project-upload'),
        'duration' => carbon_get_post_meta($id, 'duration'),
        'lead' => carbon_get_post_meta($id, 'lead'),
        'credits' => carbon_get_post_meta($id, 'credits'),
        'images' => carbon_get_post_meta($id, 'images'),
    ];
}

// -> Leichte Variante fürs Thumbnail-Raster
function get_project_teaser (int $id): array {
    $thumbnail_id = carbon_get_post_meta($id, 'thumbnail');
    $date = (string) carbon_get_post_meta($id, 'date');
    $number = (int) carbon_get_post_meta($id, 'project-id');
    $types = wp_get_post_terms($id, 'project_category', ['fields' => 'names']);
    $categories = wp_get_post_terms($id, 'main_category', ['fields' => 'slugs']);

    return [
        'url' => get_permalink($id),
        'title' => get_the_title($id),
        'number' => str_pad((string) $number, 2, '0', STR_PAD_LEFT),
        'date' => str_replace('-', '/', $date), // 2025-01-21 -> 2025/01/21
        'type' => !is_wp_error($types) && !empty($types) ? $types[0] : '',
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