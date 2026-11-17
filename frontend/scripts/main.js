// -> Work-Filter (main_category), ohne Seiten-Reload
document.addEventListener('DOMContentLoaded', () => {
    const buttons = document.querySelectorAll('[data-filter]');
    const teasers = document.querySelectorAll('[data-teaser="project"]');
    if (!buttons.length) return;

    buttons.forEach((button) => {
        button.addEventListener('click', () => {
            const filter = button.dataset.filter;

            buttons.forEach((b) => {
                const active = b === button;
                b.classList.toggle('is-active', active);
                b.setAttribute('aria-pressed', String(active));
            });

            teasers.forEach((teaser) => {
                const categories = teaser.dataset.categories.split(' ').filter(Boolean);
                teaser.hidden = !(filter === 'all' || categories.includes(filter));
            });
        });
    });
});