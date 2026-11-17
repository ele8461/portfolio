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
   );