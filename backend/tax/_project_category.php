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
   );