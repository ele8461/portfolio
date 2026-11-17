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
   );