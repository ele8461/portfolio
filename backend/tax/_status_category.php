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
   );