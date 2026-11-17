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
    <?php if (!empty($project['status'])) : ?>
        <span class="label label-status"><?= esc_html($project['status']) ?></span>
    <?php endif; ?>
</a>