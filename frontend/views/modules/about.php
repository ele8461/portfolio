<?php
$data = $args['data'];

$images = [
    ['image' => $data['image1'] ?? null, 'date' => $data['date1'] ?? ''],
    ['image' => $data['image2'] ?? null, 'date' => $data['date2'] ?? ''],
];
$socials = get_globals_socials();
?>

<section data-module="about" id="about">
    <div class="intro">
        <h1 class="title"><?= esc_html($data['title'] ?? 'about.') ?></h1>
    </div>

    <div class="content">
        <div class="images">
            <?php foreach ($images as $item) : ?>
                <?php if (!empty($item['image']['src'])) : ?>
                    <figure class="image-item">
                        <img src="<?= esc_url($item['image']['src']) ?>"
                             alt="<?= esc_attr($item['image']['alt']) ?>"
                             loading="lazy">
                        <figcaption class="date">
                            <?= esc_html(str_replace('-', '/', (string) $item['date'])) ?>
                        </figcaption>
                    </figure>
                <?php endif; ?>
            <?php endforeach; ?>
        </div>

        <div class="bio">
            <?= apply_filters('the_content', $data['bio'] ?? '') ?>
        </div>

        <div class="contact">
            <?= apply_filters('the_content', $data['contact'] ?? '') ?>
            <?php if (!empty($socials)) : ?>
                <div class="socials">
                    <?php foreach ($socials as $item) : ?>
                        <a target="_blank" href="<?= esc_url($item['link']) ?>"><?= esc_html($item['title']) ?></a>
                    <?php endforeach; ?>
                </div>
            <?php endif; ?>
        </div>
    </div>
</section>