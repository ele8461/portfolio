<mark>Hier kommt der Inhalt vom Post Type Projekt</mark>
<?php
$project = get_project_by_id(get_the_ID());
?>

<article>
    <h1><?= esc_html($project['title']) ?></h1>
    <p><?= esc_html($project['project-id']) ?></p>
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
</article>