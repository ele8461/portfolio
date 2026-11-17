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
</section>