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
</section>