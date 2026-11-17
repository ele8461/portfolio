## ./backend/carbonfields/_globals.php
```
<?php
use Carbon_Fields\Container;
use Carbon_Fields\Field;

// -> Inhaltsfeld-Konfiguration der globalen Einstellungen des Themes
Container::make('theme_options', 'Globales')
    ->add_fields([
        Field:: make('complex', 'socials', 'Socials')
            ->add_fields([
                Field:: make('text', 'title', 'Titel'),
                Field:: make('text', 'link', 'Link')
            ])
    ]);
```

## ./backend/carbonfields/_modules.php
```
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
                Field::make('image', 'image1', 'Bild 1')->set_required(),
                Field::make('date', 'date1', 'Datum Bild 1')->set_required(),
                Field::make('image', 'image2', 'Bild 2')->set_required(),
                Field::make('date', 'date2', 'Datum Bild 2')->set_required(),
                Field::make('rich_text', 'bio', 'Beschreibung')->set_required(),
                Field::make('rich_text', 'contact', 'Kontakt'),
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
}```

## ./backend/carbonfields/_project.php
```
<?php
use Carbon_Fields\Container;
use Carbon_Fields\Field;

Container::make('post_meta', 'Projekt')
    ->where('post_type', '=', 'project')
    ->add_fields([
        Field::make('text', 'subtitle', 'Untertitel'),
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
    ]);```

## ./backend/carbonfields/index.php
```
<?php
/**
 * Alles, was mit Carbon Fields zu tun hat, ist in diesem Ordner verwaltet.
 * Wenn ein neuer Post Type oder eine Taxonomie spezifische Carbon Fields
 * benötigen, kann eine neue Konfigurationsdatei in diesem Ordner erstellt
 * und in diese Datei importiert werden.
 *
 * Dokumentation: https://docs.carbonfields.net/
 */

add_action('carbon_fields_register_fields', function () {
    require_once __DIR__ . '/_globals.php';
    require_once __DIR__ . '/_modules.php';
    require_once __DIR__ . '/_project.php';
});
```

## ./backend/cpt/_project.php
```
<?php
register_post_type('project', [
    'label' => 'Projekt',
    'labels' => [
        'name' => 'Projekte',
        'singular_name' => 'Projekt',
        'menu_name' => 'Projekte',
        'name_admin_bar' => 'Projekt',
        'all_items' => 'Alle Projekte',
        'add_new_item' => 'Neues Projekt hinzufügen',
        'add_new' => 'Neues Projekt',
        'new_item' => 'Neues Projekt',
        'edit_item' => 'Projekt bearbeiten',
        'update_item' => 'Projekt updaten',
        'view_item' => 'Projekt ansehen',
        'view_items' => 'Projekte ansehen',
        'search_items' => 'Projekt suchen',
        'not_found' => 'Kein Projekt gefunden',
        'not_found_in_trash' => 'Kein Projekt im Papierkorb gefunden',
    ],
    'supports' => ['title'],
    'hierarchical' => false,
    'public' => true,
    'show_ui' => true,
    'show_in_menu' => true,
    'menu_position' => 20,
    'menu_icon' => 'dashicons-video-alt3',
    'show_in_admin_bar' => false,
    'show_in_nav_menus' => false,
    'has_archive' => false,
    'exclude_from_search' => true,
    'publicly_queryable' => true,
    'capability_type' => 'post',
    'show_in_rest' => false,
    'rewrite' => [
        'slug' => 'project',
        'with_front' => false,
        'pages' => true,
        'feeds' => true,
    ],
]);```

## ./backend/cpt/index.php
```
<?php
/**
 * In diesem Ordner werden Custom Post Types verwaltet.
 * Für jeden Custom Post Type muss eine neue Datei erstellt werden
 * und in dieser Datei hinzugefügt werden. Der Dateiname sollte
 * dem Slug des Post Typs entsprechen.
 *
 * Dokumentation: https://developer.wordpress.org/reference/functions/register_post_type/
 */

add_action('init', function () {
    require_once __DIR__ . '/_project.php';
}, 0);
```

## ./backend/getter/_globals.php
```
<?php

// -> Socials (Titel + Link) aus den globalen Einstellungen
function get_globals_socials (): array {
    $socials = carbon_get_theme_option('socials');
    return is_array($socials) ? $socials : [];
}```

## ./backend/getter/_project.php
```
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
}```

## ./backend/getter/index.php
```
<?php
require_once __DIR__ . '/_globals.php';
require_once __DIR__ . '/_project.php';
```

## ./backend/helpers/index.php
```
<?php
/**
 * Funktionen in dieser Datei können überall im Projekt verwendet werden.
 * Wenn eine neue globale Funktion benötigt wird, bitte hier ergänzen.
 *
 * Diese globalen Funktionen sind nicht Wordpress-spezifisch.
 */

// -> PHP-Daten in der Browser-Konsole anzeigen
function js_log(mixed ...$content): void
{
    foreach ($content as $c) {
        echo '<script>console.log(' . json_encode($c) . ')</script>';
    }
}

// -> Details einer Mediendatei anhand der ID laden
function get_media_by_id(int|string $id, string $size = 'm'): false|array
{
    $id = (int) $id;
    $data = [
        'title' => get_the_title($id),
        'alt' => get_post_meta($id, '_wp_attachment_image_alt', true) ?: get_the_title($id),
    ];
    $image = wp_get_attachment_image_src($id, $size);
    if ($image) {
        $data['src'] = $image[0];
        $data['type'] = 'image';
    } else {
        $data['src'] = wp_get_attachment_url($id);
        $data['type'] = get_post_mime_type($id);
    }
    return $data;
}

// -> Ein Menu anhand des Keys laden
function get_menu_by_slug(string $slug): array
{
    $theme_locations = get_nav_menu_locations();
    if (!array_key_exists($slug, $theme_locations)) {
        return [];
    }
    $menu_obj = get_term($theme_locations[$slug], 'nav_menu');
    $menu = wp_get_nav_menu_items($menu_obj->name) ?: [];
    $items = [];
    foreach ($menu as $item) {
        $items[] = [
            'ID' => (int) $item->ID,
            'title' => $item->title,
            'url' => $item->url,
            'target' => $item->target,
        ];
    }
    return $items;
}
```

## ./backend/init/index.php
```
<?php
/**
 * In dieser Datei sind Funktionen drin, welche das Backend aufräumen
 * und optimieren. Diese Datei muss in der Regel nicht bearbeitet werden.
 */

// -> add image sizes
add_image_size('preload', 20, 20);
add_image_size('xxs', 100, 100);
add_image_size('xs', 300, 300);
add_image_size('s', 600, 600);
add_image_size('m', 1200, 1200);
add_image_size('l', 1800, 1800);
add_image_size('xl', 2800, 2800);

// -> enable block editor and clean up
add_filter('use_block_editor_for_post_type', function () {
    return false;
});
add_filter('init', function () {
    remove_post_type_support('page', 'editor');
    remove_action('wp_head', 'wp_generator');
    remove_action('wp_head', 'rsd_link');
    remove_action('wp_head', 'wlwmanifest_link');
});
add_action(
    'wp_enqueue_scripts',
    function () {
        wp_dequeue_style('wp-block-library');
        wp_dequeue_style('wp-block-library-theme');
        wp_dequeue_style('wc-blocks-style');
        wp_dequeue_style('global-styles');
        remove_action('wp_head', 'print_emoji_detection_script', 7);
        remove_action('admin_print_scripts', 'print_emoji_detection_script');
        remove_action('wp_print_styles', 'print_emoji_styles');
        remove_action('admin_print_styles', 'print_emoji_styles');
    },
    100,
);

// -> allow uploading svg images
function wp_init_extend_upload_mimes ($mimes) {
    $mimes['svg'] = 'image/svg+xml';
    return $mimes;
}

add_filter('upload_mimes', 'wp_init_extend_upload_mimes');

// -> remove posts from admin
function remove_posts_from_admin ($args, $post_type) {
    if ($post_type === 'post') {
        $args['public'] = false;
        $args['show_ui'] = false;
        $args['show_in_menu'] = false;
        $args['show_in_admin_bar'] = false;
        $args['show_in_nav_menus'] = false;
        $args['can_export'] = false;
        $args['has_archive'] = false;
        $args['exclude_from_search'] = true;
        $args['publicly_queryable'] = false;
        $args['show_in_rest'] = false;
    }
    return $args;
}

add_filter('register_post_type_args', 'remove_posts_from_admin', 10, 2);

// -> remove categories and tags from admin
function remove_categories_and_tags_from_admin ($args, $taxonomy) {
    if (in_array($taxonomy, ['category', 'post_tag'], true)) {
        $args['public'] = false;
        $args['show_ui'] = false;
        $args['show_in_menu'] = false;
        $args['show_in_nav_menus'] = false;
        $args['show_admin_column'] = false;
        $args['show_in_rest'] = false;
        $args['meta_box_cb'] = false;
    }
    return $args;
}

add_filter('register_taxonomy_args', 'remove_categories_and_tags_from_admin', 10, 2);

// -> remove wp comment functionality
function remove_comments_admin_menu (): void {
    remove_menu_page('edit-comments.php'); // remove comments
}

add_action('admin_menu', 'remove_comments_admin_menu');
function remove_comment_support (): void {
    remove_post_type_support('post', 'comments');
    remove_post_type_support('page', 'comments');
}

add_action('init', 'remove_comment_support', 100);
function remove_comments_in_admin_bar (): void {
    global $wp_admin_bar;
    $wp_admin_bar->remove_menu('comments');
}

add_action('wp_before_admin_bar_render', 'remove_comments_in_admin_bar');

// -> remove unused backend items
function remove_backend_items (): void {
    global $submenu;
    if (isset($submenu['themes.php'])) {
        foreach ($submenu['themes.php'] as $key => $item) {
            $slug = $item[2];
            if (
                str_contains($slug, 'customize.php') ||
                str_contains($slug, 'theme-editor.php') ||
                str_contains($slug, 'site-editor.php') ||
                str_contains($slug, 'font-library.php') ||
                str_contains($slug, 'post_type=wp_template') ||
                str_contains($slug, 'post_type=wp_font')
            ) {
                unset($submenu['themes.php'][$key]);
            }
        }
    }
}

add_action('admin_menu', 'remove_backend_items', 999);

// -> block direct access to disabled pages
function block_disabled_design_pages (): void {
    global $pagenow;
    $blocked_pages = [
        'theme-editor.php',
        'customize.php',
        'site-editor.php',
        'font-library.php'
    ];
    if (in_array($pagenow, $blocked_pages, true)) {
        wp_safe_redirect(admin_url('themes.php'));
        exit;
    }
}

add_action('admin_init', 'block_disabled_design_pages');

// -> Styles und Scripts aus frontend/ einbinden
add_action('wp_enqueue_scripts', function (): void {
    $dir = get_template_directory();
    $uri = get_template_directory_uri();

    // filemtime als Version: Browser lädt automatisch neu, wenn die Datei geändert wurde
    wp_enqueue_style(
        'main',
        $uri . '/frontend/styles/main.css',
        [],
        filemtime($dir . '/frontend/styles/main.css'),
    );
    wp_enqueue_script(
        'main',
        $uri . '/frontend/scripts/main.js',
        [],
        filemtime($dir . '/frontend/scripts/main.js'),
        ['in_footer' => true, 'strategy' => 'defer'],
    );
});
```

## ./backend/nav/index.php
```
<?php
/**
 * In dieser Datei werden Navigationen / Menus registriert.
 * Um eine Navigation im Backend erstellen zu können, muss diese
 * hier registriert werden.
 *
 * Dokumentaion: https://developer.wordpress.org/reference/functions/register_nav_menus/
 */

add_filter('init', function () {
    register_nav_menus([
        'main' => 'Hauptnavigation',
        'legals' => 'Rechtliches'
    ]);
});
```

## ./backend/tax/_genre_category.php
```
   <?php
   register_taxonomy(
     'genre_category',
     ['project'],
     [
       'label' => 'Genre',
       'labels' => [
         'name' => 'Genre',
         'singular_name' => 'Genre',
         'menu_name' => 'Genre-Kategorien',
         'all_items' => 'Alle Genres',
         'edit_item' => 'Genre bearbeiten',
         'view_item' => 'Genre ansehen',
         'update_item' => 'Genre updaten',
         'add_new_item' => 'Neues Genre hinzufügen',
       ],
       'public' => true,
       'show_in_rest' => true,
       'show_in_nav_menus' => true,
       'show_admin_column' => true,
       'query_var' => true,
       'hierarchical' => true,
       'rewrite' => ['slug' => 'genre'],
     ],
   );```

## ./backend/tax/_main_category.php
```
   <?php
   register_taxonomy(
     'main_category',
     ['project'],
     [
       'label' => 'Hauptkategorie',
       'labels' => [
         'name' => 'Hauptkategorien',
         'singular_name' => 'Hauptkategorie',
         'menu_name' => 'Hauptkategorien',
         'all_items' => 'Alle Haupttkategorien',
         'edit_item' => 'Hauptkategorie bearbeiten',
         'view_item' => 'Hauptkategorie ansehen',
         'update_item' => 'Hauptkategorie updaten',
         'add_new_item' => 'Neue Hauptkategorie hinzufügen',
       ],
       'public' => true,
       'show_in_rest' => true,
       'show_in_nav_menus' => true,
       'show_admin_column' => true,
       'query_var' => true,
       'hierarchical' => true,
       'rewrite' => ['slug' => 'hauptkategorie'],
     ],
   );```

## ./backend/tax/_project_category.php
```
   <?php
   register_taxonomy(
     'project_category',
     ['project'],
     [
       'label' => 'Projektart',
       'labels' => [
         'name' => 'Projektart',
         'singular_name' => 'Projektart',
         'menu_name' => 'Projektarten',
         'all_items' => 'Alle Projektarten',
         'edit_item' => 'Projektart bearbeiten',
         'view_item' => 'Projektart ansehen',
         'update_item' => 'Projektart updaten',
         'add_new_item' => 'Neue Projektart hinzufügen',
       ],
       'public' => true,
       'show_in_rest' => true,
       'show_in_nav_menus' => true,
       'show_admin_column' => true,
       'query_var' => true,
       'hierarchical' => true,
       'rewrite' => ['slug' => 'projektart'],
     ],
   );```

## ./backend/tax/_status_category.php
```
   <?php
   register_taxonomy(
     'status_category',
     ['project'],
     [
       'label' => 'Status',
       'labels' => [
         'name' => 'Status',
         'singular_name' => 'Status',
         'menu_name' => 'Status-Kategorien',
         'all_items' => 'Alle Status-Kategorien',
         'edit_item' => 'Status bearbeiten',
         'view_item' => 'Status ansehen',
         'update_item' => 'Status updaten',
         'add_new_item' => 'Neue Status-Kategorie hinzufügen',
       ],
       'public' => true,
       'show_in_rest' => true,
       'show_in_nav_menus' => true,
       'show_admin_column' => true,
       'query_var' => true,
       'hierarchical' => true,
       'rewrite' => ['slug' => 'status'],
     ],
   );```

## ./backend/tax/index.php
```
<?php
/**
* Taxonomien werden in diesem Ordner verwaltet. Für jede Taxonomie muss eine
* neue Datei erstellt werden und in dieser Datei importiert werden. Der Dateiname
* sollte dem Slug der Taxonomie entsprechen.
*
* Dokumentation: https://developer.wordpress.org/reference/functions/register_taxonomy/
*/

add_action('init', function () {
    require_once __DIR__ . '/_main_category.php';
    require_once __DIR__ . '/_project_category.php';
    require_once __DIR__ . '/_genre_category.php';
    require_once __DIR__ . '/_status_category.php';
}, 0);
```

## ./footer.php
```
<script src="<?php bloginfo('template_directory'); ?>/frontend/scripts/main.js" type="module"></script>
<?php wp_footer(); ?>
</body>
</html>
```

## ./frontend/scripts/main.js
```
// -> Work-Filter (main_category), ohne Seiten-Reload
document.addEventListener('DOMContentLoaded', () => {
    const buttons = document.querySelectorAll('[data-filter]');
    const teasers = document.querySelectorAll('[data-teaser="project"]');
    if (!buttons.length) return;

    buttons.forEach((button) => {
        button.addEventListener('click', () => {
            const filter = button.dataset.filter;

            buttons.forEach((b) => {
                const active = b === button;
                b.classList.toggle('is-active', active);
                b.setAttribute('aria-pressed', String(active));
            });

            teasers.forEach((teaser) => {
                const categories = teaser.dataset.categories.split(' ').filter(Boolean);
                teaser.hidden = !(filter === 'all' || categories.includes(filter));
            });
        });
    });
});```

## ./frontend/styles/_about.css
```
```

## ./frontend/styles/_resets.css
```
* {
    margin: 0 0;
    padding: 0 0;
    box-sizing: border-box;
}
html {
    scroll-behavior: smooth;
}
body {
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}
img {
    vertical-align: bottom;
}
```

## ./frontend/styles/main.css
```
@import "_fonts.css";
@import "_resets.css";

/* Definition of base styles. */
:root {
    /* colors */
    --color-white: #F5F5F5;
    --color-black: #000000;
    /* gaps & sizes */
    --gap-around: 40px;
    /* fonts */
    --font-h1: normal 64px/120% serif;
    --font-main: Georgia, serif;
    --font-small: normal 12px/1.2 var(--font-main);
    --font-filter: normal 18px/1 var(--font-main);
    body {
        background-color: var(--color-black);
        color: var(--color-white);
        font-family: var(--font-main);
    }
    a { color: inherit; }
}

/* Styling of all available layout components. */
[data-layout="header"] {
    padding: var(--gap-around);
    background-color: var(--color-black);
    position: sticky;
    top: 0;
    z-index: 100;
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
    .nav-container {
        .nav {
            list-style: none;
            display: flex;
            flex-direction: row; justify-content: flex-end;
            align-self: center;
            gap: 20px;
            a {
                text-decoration: none;
                color: var(--color-white);
            }
        }
    }
}

[data-layout="footer"] {
    padding: var(--gap-around);
    background-color: var(--color-black);
    .nav-container {
        .nav {
            list-style: none;
            display: flex;
            flex-direction: row; justify-content: flex-end;
            align-self: center;
            gap: 20px;
            a {
                text-decoration: none;
                color: var(--color-white);
            }
        }
    }
}

/* Styling of all available page components. */
[data-page] {
    width: 100%;
    height: 100%;
}

/* Styling of all available module components. */
[data-module] {
    overflow: clip;
    position: relative;
    width: 100%;
}

[data-module="all_projects"],
[data-module="selected_projects"] {
    display: grid;
    grid-template-columns: 1fr 2fr;
    gap: var(--gap-around);
    padding: var(--gap-around);
    & > .intro {
        align-self: start;
        position: sticky;
        top: 40vh;
        .title {
            font: var(--font-h1);
            margin-bottom: 24px;
        }
        .filters {
            list-style: none;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }
        .filter {
            font: var(--font-filter);
            color: var(--color-white);
            background: transparent;
            border: 1px solid var(--color-white);
            border-radius: 999px;
            padding: 8px 16px;
            cursor: pointer;
            &.is-active {
                background: var(--color-white);
                color: var(--color-black);
            }
        }
    }
    & > .grid {
        column-count: 2;
        column-gap: var(--gap-around);
    }
}

/* Styling of all available teaser components. */
[data-teaser="project"] {
    display: block;
    position: relative;
    border: 1px solid var(--color-white);
    padding: 22px 10px;
    margin-bottom: var(--gap-around);
    break-inside: avoid;
    text-decoration: none;
    color: var(--color-white);
    &[hidden] { display: none; }
    & > .image {
        display: block;
        width: 100%;
        height: auto;
    }
    & > .label {
        position: absolute;
        font: var(--font-small);
        .number { margin-right: 10px; }
    }
    & > .label-title { top: 5px; left: 8px; }
    & > .label-type  { top: 5px; right: 8px; }
    & > .label-date  { bottom: 5px; right: 8px; }
}

/* Styling of utility classes, can be added anywhere in the project. */

/* BREAKPOINT: 3xl */
@media (max-width: 1514px) {}

/* BREAKPOINT: xl */
@media (max-width: 1280px) {}

/* BREAKPOINT: lg */
@media (max-width: 1024px) {}

/* BREAKPOINT: md */
@media (max-width: 768px) {}

/* BREAKPOINT: sm */
@media (max-width: 640px) {}

/* BREAKPOINT: xs */
@media (max-width: 425px) {}

/* BREAKPOINT: xxs */
@media (max-width: 400px) {}

@media (max-width: 768px) {
    [data-module="all_projects"]
    [data-module="selected_projects"]  {
        grid-template-columns: 1fr;
        & > .intro { position: static; }
        & > .grid { column-count: 1; }
    }
}
```

## ./frontend/views/layout/footer.php
```
<?php
    $menu = get_menu_by_slug(slug: 'legals');
    $socials = get_globals_socials();
?>

<footer data-layout="footer">
    <mark>© elena fankhauser 2026</mark>
    <div class="socials">
        <?php foreach ($socials as $item) : ?>
            <a target="_blank" href="<?= $item['link'] ?>" aria-label="Link zu <?= $item['title'] ?>">
                <?= $item['title'] ?>
            </a>
        <?php endforeach; ?>
    </div>
    <nav class="nav-container">
        <ul class="nav">
            <?php foreach ($menu as $item) : ?>
                <li class="nav-item">
                    <a target="<?= $item['target'] ?>" href="<?= $item['url'] ?>">
                        <?= $item['title'] ?>
                    </a>
                </li>
            <?php endforeach; ?>
        </ul>
    </nav>
</footer>```

## ./frontend/views/layout/header.php
```
<?php
    $menu = get_menu_by_slug(slug: 'main');
?>

<header data-layout="header">
    <mark>elena fankhauser | writer & filmmaker</mark>
    <nav class="nav-container">
        <ul class="nav">
            <?php foreach ($menu as $item) : ?>
                <li class="nav-item">
                    <a target="<?= $item['target'] ?>" href="<?= $item['url'] ?>"><?= $item['title'] ?></a>
                </li>
            <?php endforeach; ?>
        </ul>
    </nav>
</header>```

## ./frontend/views/modules/about.php
```
```

## ./frontend/views/modules/all_projects.php
```
<?php
$data = $args['data'];
?>

<section data-module="all_projects">
    <div class="intro">
        <h1 class="title"><?= esc_html($data['title']) ?></h1>
        <ul class="filters">
            <li><button type="button" class="filter is-active" data-filter="all" aria-pressed="true">all</button></li>
            <?php foreach ($data['filters'] as $filter) : ?>
                <li>
                    <button type="button" class="filter" data-filter="<?= esc_attr($filter['slug']) ?>" aria-pressed="false">
                        <?= esc_html($filter['name']) ?>
                    </button>
                </li>
            <?php endforeach; ?>
        </ul>
    </div>

    <div class="grid">
        <?php foreach ($data['projects'] as $project) : ?>
            <?php get_template_part('frontend/views/teaser/project', null, ['data' => $project]); ?>
        <?php endforeach; ?>
    </div>
</section>```

## ./frontend/views/modules/selected_projects.php
```
<?php
$data = $args['data'];
?>

<section data-module="all_projects">
    <div class="intro">
        <h1 class="title"><?= esc_html($data['title']) ?></h1>
    </div>

    <div class="grid">
        <?php foreach ($data['projects'] as $project) : ?>
            <?php get_template_part('frontend/views/teaser/project', null, ['data' => $project]); ?>
        <?php endforeach; ?>
    </div>
</section>```

## ./frontend/views/pages/page.php
```
<main data-page="page">
    <?php render_modules(); ?>
</main>
```

## ./frontend/views/pages/project.php
```
<?php
$project = get_project_by_id(get_the_ID());
?>

<article>
    <h1><?= esc_html($project['title']) ?></h1>
    <p><?= esc_html($project['subtitle']) ?></p>
    <p><?= esc_html($project['date']) ?></p>

    <?php if ($project['thumbnail']): ?>
        <?= wp_get_attachment_image($project['thumbnail'], 'large') ?>
    <?php endif; ?>

    <?php if ($project['project-upload']): ?>
        <div><?= $project['project-upload'] ?></div>
    <?php endif; ?>

    <?php if ($project['duration']): ?>
        <p><?= esc_html($project['duration']) ?></p>
    <?php endif; ?>

    <div><?= apply_filters('the_content', $project['lead']) ?></div>

    <?php if ($project['credits']): ?>
        <div><?= apply_filters('the_content', $project['credits']) ?></div>
    <?php endif; ?>

    <?php foreach ($project['images'] as $image_id): ?>
        <?= wp_get_attachment_image($image_id, 'large') ?>
    <?php endforeach; ?>
</article>```

## ./frontend/views/teaser/project.php
```
<?php
$project = $args['data'];
?>

<a class="teaser" data-teaser="project"
   href="<?= esc_url($project['url']) ?>"
   data-categories="<?= esc_attr(implode(' ', $project['main_categories'])) ?>">
    <?php if ($project['thumbnail']) : ?>
        <img class="image" src="<?= esc_url($project['thumbnail']['src']) ?>" alt="<?= esc_attr($project['thumbnail']['alt']) ?>" loading="lazy">
    <?php endif; ?>
    <span class="label label-title"><span class="number"><?= esc_html($project['number']) ?></span><?= esc_html($project['title']) ?></span>
    <span class="label label-type"><?= esc_html($project['type']) ?></span>
    <span class="label label-date"><?= esc_html($project['date']) ?></span>
</a>```

## ./functions.php
```
<?php
require_once __DIR__ . '/backend/init/index.php';
require_once __DIR__ . '/backend/helpers/index.php';
require_once __DIR__ . '/backend/nav/index.php';
require_once __DIR__ . '/backend/cpt/index.php';
require_once __DIR__ . '/backend/tax/index.php';
require_once __DIR__ . '/backend/carbonfields/index.php';
require_once __DIR__ . '/backend/getter/index.php';```

## ./header.php
```
<!DOCTYPE html>
<html lang="<?php bloginfo('language') ?>">
<head>
    <meta charset="<?php bloginfo('charset') ?>">
    <link rel="stylesheet" href="<?= get_template_directory_uri() ?>/frontend/styles/main.css">
    <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover" />
    <title><?php bloginfo('name') ?></title>
    <?php wp_head(); ?>
</head>
<body>
```

## ./index.php
```
<?php get_header() ?>
<?php get_template_part('frontend/views/layout/header') ?>
<?php get_template_part('frontend/views/layout/footer') ?>
<?php get_footer() ?>
```

## ./page.php
```
<?php get_header() ?>
<?php get_template_part('frontend/views/layout/header') ?>
<?php get_template_part('frontend/views/pages/page') ?>
<?php get_template_part('frontend/views/layout/footer') ?>
<?php get_footer() ?>
```

## ./single-project.php
```
<?php get_header() ?>
<?php get_template_part('frontend/views/layout/header') ?>
<?php get_template_part('frontend/views/pages/project') ?>
<?php get_template_part('frontend/views/layout/footer') ?>
<?php get_footer() ?>```

## ./style.css
```
/**
 * Theme Name: Portfolio Starter Theme
 * Description: Dieses Starter-Theme wurde für den Einsatz im IM5-Modul im HS26 entwickelt.
 * Version: 1.0.0
 * Author: Lea Moser | lea.moser@fhgr.ch | FHGR
 */
```

