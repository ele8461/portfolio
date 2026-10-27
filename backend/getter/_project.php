<?php
function get_project_by_id (int $id): array {
    return [
        'title' => get_the_title($id),
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