<?php
$project = get_project_by_id(get_the_ID());
$media = $project['media'];

// -> Meta-Zeile: leere Einträge fallen automatisch weg
$meta = array_filter([
    implode(', ', $project['project_categories']),
    implode(', ', $project['genre_categories']),
    $project['duration'],
    $project['year'],
]);
?>

<main data-page="project">
    <!-- Standard: Work. Falls von Selected Work gekommen, setzt main.js den Link um -->
    <a class="back" data-back href="<?= esc_url(home_url('/#work')) ?>" aria-label="Zurück">
        <svg viewBox="0 0 40 12" width="40" height="12" fill="none" stroke="currentColor" stroke-width="1" aria-hidden="true">
            <path d="M40 6H1M6 1L1 6l5 5"/>
        </svg>
    </a>

    <article class="project">
        <?php if ($media) : ?>
            <div class="media media-<?= esc_attr($media['type']) ?>">
                <?php if ($media['type'] === 'link') : ?>
                    <?= $media['html'] ?>
                <?php elseif ($media['type'] === 'video') : ?>
                    <video controls preload="metadata" playsinline
                           src="<?= esc_url($media['src']) ?>"
                           <?php if ($media['poster']) : ?>poster="<?= esc_url($media['poster']) ?>"<?php endif; ?>></video>
                <?php elseif ($media['type'] === 'audio') : ?>
                    <?php if ($media['poster']) : ?>
                        <img src="<?= esc_url($media['poster']) ?>" alt="">
                    <?php endif; ?>
                    <audio controls preload="metadata" src="<?= esc_url($media['src']) ?>"></audio>
                <?php elseif ($media['type'] === 'image') : ?>
                    <img src="<?= esc_url($media['image']['src']) ?>" alt="<?= esc_attr($media['image']['alt']) ?>">
                <?php endif; ?>
            </div>
        <?php endif; ?>

        <h1 class="title"><?= esc_html($project['title']) ?></h1>

        <?php if (!empty($project['subtitle'])) : ?>
            <p class="subtitle"><?= esc_html($project['subtitle']) ?></p>
        <?php endif; ?>

        <?php if ($meta) : ?>
            <ul class="meta">
                <?php foreach ($meta as $item) : ?>
                    <li><?= esc_html($item) ?></li>
                <?php endforeach; ?>
            </ul>
        <?php endif; ?>

        <div class="lead"><?= apply_filters('the_content', $project['lead']) ?></div>

        <?php if (!empty($project['credits'])) : ?>
            <div class="credits"><?= apply_filters('the_content', $project['credits']) ?></div>
        <?php endif; ?>

        <?php if (!empty($project['images'])) : ?>
            <div class="gallery">
                <?php foreach ($project['images'] as $image) : ?>
                    <figure class="gallery-item">
                        <img src="<?= esc_url($image['src']) ?>" alt="<?= esc_attr($image['alt']) ?>" loading="lazy">
                    </figure>
                <?php endforeach; ?>
            </div>
        <?php endif; ?>
    </article>
</main>