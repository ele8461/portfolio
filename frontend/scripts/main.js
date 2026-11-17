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

// -> Merken, von welchem Modul aus ein Projekt geöffnet wurde (Work / Selected Work)
document.addEventListener('click', (event) => {
    const teaser = event.target.closest('[data-teaser="project"]');
    const module = teaser?.closest('[data-module]');
    if (!module?.id) return;
    try {
        sessionStorage.setItem('project-origin', location.pathname + location.search + '#' + module.id);
    } catch (e) {}
});

// -> Zurück-Pfeil auf der Projektseite auf die gemerkte Stelle setzen
document.addEventListener('DOMContentLoaded', () => {
    const back = document.querySelector('[data-back]');
    if (!back) return;
    try {
        const origin = sessionStorage.getItem('project-origin');
        if (origin) back.href = origin;
    } catch (e) {}
});