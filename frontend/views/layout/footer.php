<?php
    $menu = get_menu_by_slug(slug: 'legals');
    $socials = get_globals_socials();
    js_log($socials)
?>

<footer data-layout="footer">
    <mark>© elena fankhauser 2026</mark>
    <div class="socials">
        <?php foreach ($socials as $item) : ?>
            <a target="_blank" href="<?= $item['link'] ?>" aria-label="Link zu <?= $item['title'] ?>">
                <?= $item['title'] ?>
            </a>
        <?php endforeach; ?>
    </div>
    <nav class="nav-container">
        <ul class="nav">
            <?php foreach ($menu as $item) : ?>
                <li class="nav-iteln">
                    <a target="<?= $item['target'] ?>" href="<?= $item['url'] ?>">
                        <?= $item['title'] ?>
                    </a>
                </li>
            <?php endforeach; ?>
        </ul>
    </nav>
<footer>