# IM5 Wordpress `Portfolio Elena Fankhauser`
> Beschreibung.

## Aufbau des Themes

### 🚧 Ordner `backend`
In diesem Ordner befinden sich alle Dateien, die für die Backend-Funktionen des Themes benötigt werden. Immer wenn es um Funktionalität geht, muss in diesem Ordner gearbeitet werden.


### 🏠 Ordner `frontend`
In diesem Ordner befinden sich alle Dateien, die mit dem Frontend der Webseite zusammenhängen. 

### 📚 Ordner `manuals`
In diesem Ordner sind Anleitungen für die verschiedenen Erweiterungen abgelegt, die man in diesem Theme machen kann. Natürlich kann das Theme auch anderweitig ausgebaut werden, diese Anleitungen decken einfach die "Standard-Erweiterungen" ab.

Die Anleitungen sind so konzipiert, dass auch eine KI sie lesen kann und bei der Entwicklung der Erweiterungen unterstützen kann.


## Projektstruktur

Das Projekt ist ein WordPress-Theme, das in **Backend** (Logik, Datenstruktur, CMS) und **Frontend** (Darstellung, Assets) getrennt ist. Die Planung der Inhaltstypen steht im CMS-Konzept (`manuals/`).

### Hauptstruktur

```
portfolio/
├── .vscode/            Editor-Einstellungen
├── backend/            CMS-Logik (PHP)
├── frontend/           Views, Styles, Scripts, Assets
├── manuals/            Dokumentation, z. B. CMS-Konzept
├── .gitignore
├── footer.php          WP-Template: Footer
├── functions.php       WP-Einstiegspunkt, lädt das Backend
├── header.php          WP-Template: Header
├── index.php           WP-Template: Fallback
├── page.php            WP-Template: Seiten (Modulbaukasten)
├── README.md
├── single-project.php  WP-Template: Einzelprojekt
└── style.css           Theme-Header (WP-Pflichtdatei)
```

### Backend

```
backend/
├── carbonfields/       Felddefinitionen (Carbon Fields)
│   ├── _globals.php    Globals (Name, Socials)
│   ├── _modules.php    Module (selected work, work, about)
│   ├── _project.php    Felder des Post Types „project“
│   └── index.php       Lädt alle Dateien des Ordners
├── cpt/                Custom Post Types
│   ├── _project.php    Post Type „project“
│   └── index.php
├── getter/             Funktionen zum Abrufen von Daten fürs Frontend
│   ├── _globals.php
│   ├── _project.php
│   └── index.php
├── helpers/            Wiederverwendbare Hilfsfunktionen
│   └── index.php
├── init/               Theme-Setup (Support, Enqueue von Styles/Scripts)
│   └── index.php
├── nav/                Menü-Registrierung (main, legals)
│   └── index.php
└── tax/                Taxonomien
    ├── _genre_category.php
    ├── _main_category.php
    ├── _project_category.php
    ├── _status_category.php
    └── index.php
```

### Frontend

```
frontend/
├── assets/
│   └── fonts/          Schriftdateien
├── scripts/
│   └── main.js
├── styles/
│   ├── _fonts.css      @font-face-Definitionen
│   ├── _resets.css     CSS-Reset
│   └── main.css        Haupt-Stylesheet (bindet Partials ein)
└── views/
    ├── layout/         Wiederkehrende Layout-Teile
    │   ├── footer.php
    │   └── header.php
    ├── modules/        Ein Template pro CMS-Modul
    │   └── example.php
    ├── pages/          Seiten-Templates
    │   ├── page.php
    │   └── project.php
    └── teaser/         Teaser-/Vorschau-Komponenten
```

## Namenskonventionen

| Regel | Beschreibung | Beispiel |
|---|---|---|
| `index.php` | Jeder Backend-Ordner hat eine `index.php`, die die Dateien des Ordners einbindet. | `backend/cpt/index.php` |
| `_` Präfix | Einzelne Bausteine/Partials beginnen mit Unterstrich und werden über die `index.php` geladen, nicht direkt. | `_project.php`, `_fonts.css` |
| Benennung nach Inhalt | Dateiname = Slug des Inhalts (Post Type, Modul, Taxonomie). | `_project.php` ↔ Slug `project` |
| Gleicher Name pro Schicht | Ein Inhaltstyp hat in jeder Schicht eine gleichnamige Datei. | `cpt/_project.php`, `carbonfields/_project.php`, `getter/_project.php` |
| Kleinschreibung | Alle Datei- und Ordnernamen in Kleinbuchstaben. | `single-project.php` |
| Taxonomien | Dateiname `_<name>_category.php`. | `_status_category.php` |

## Datenfluss

```
tax / cpt / carbonfields   →   definieren, was im CMS existiert
          ↓
       getter              →   holen die Daten aus der Datenbank
          ↓
  views (frontend)         →   geben die Daten als HTML aus
```

1. **`functions.php`** lädt `backend/*/index.php`.
2. **`cpt`, `tax`, `carbonfields`, `nav`** registrieren Post Types, Taxonomien, Felder und Menüs.
3. **`getter`** stellt die Daten bereit, die **`views`** darstellen.
4. **`init`** bindet Styles und Scripts aus `frontend/` ein.