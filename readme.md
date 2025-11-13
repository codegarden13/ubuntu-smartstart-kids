<h1 align="center">Ubuntu SmartStart Kids 🧒🐧</h1>

<p align="center">
  <img src="./logo.png" alt="Illustration des Projekts" width="100%">
  <div align="center"><strong>erster Notebook.</strong></div>




<div>
  <a href="#installation">⚙️ Installation</a> • 
  <a href="#software-auswahl">📦 Software-Auswahl</a>
  <a href="#sicherheit">📦 Software-Auswahl</a>
  <a href="#sicherheit--verantwortung">🔐 Sicherheit & Verantwortung</a>
  <div>
</p>

Offene und kompatible Alternative zu Windows / Mac für Kinder und Jugendliche (ca. 10–14 Jahre), die gerne malen, gestalten, experimentieren, programmieren und lernen. Neben Medienverständniss soll **Technik, Kunst, Medien, Musik, Programmierung** gefördert oder ermöglicht werden.

Schulumgebung mit **Microsoft Teams / O365** (Kompatibilität ist berücksichtigt)
- Vermeidet kommerzielle Cloud-Tools, wo möglich.

## Installation

- Installiert **Systemwerkzeuge** und Software **nur** per `apt`, **nur Paketquellen oder `.deb`-Installationen** – kein Snap, kein Flatpak.
- Deinstalliert zuerst Snap von Ubuntu, um das als einziges damit vorinstallierte Programm Firefox durch den offiziellen Firefox zu ersetzen (APT)

- `install.sh` – Einstiegspunkt für die Installation, holt zu installiernde Komponenten aus software-list.txt
- Weitere `install-*.sh`- Dateien für Teilinstallationen
- toggle-app.sh isnstalliert, wenn die Software fehlt, löscht ansonsten.
- `uninstall.sh` – Entfernt installierte Komponenten basierenden auf software-list.txt/ optional
- `install-browser.sh` – Installiert Firefox & Edge 
- `configure-desktop.sh` – Passt GNOME-Einstellungen an, muss im Userkontext aufgeführt werden

## 🔐 Sicherheit & Verantwortung
- Alles aus offiziellen Quellen bzw. als .deb geprüft eingebunden
- Keine automatisierte Konfiguration von Cloud-Logins oder persönlichen Konten
- Eltern/Betreuende sollten Installationen einmal manuell überprüfen.

> ⚠️ Mail-Clients wie `geary` oder `thunderbird` sind **deaktiviert**, da viele Schulen Microsoft 365/Teams verwenden. 
> Das ist auch der Grund für Edge, der auch auf den Schulrechnern läuft. Die Lesezeichen lassen sich syncronisieren.



## 🧩 Software-Auswahl

### System & Entwicklung

🧩 1. Junior Programming (Concept)

“Junior programming” is a category of educational software aimed at helping children (roughly ages 6–12) learn programming logic through visual, playful interfaces.

It emphasizes:
	•	Building with blocks rather than typing code.
	•	Immediate visual feedback (animations, sounds, or actions).
	•	Concepts like loops, conditions, variables, and events, introduced through games or projects.

| Tool            | Zweck                          |
|----------------|---------------------------------|
| `curl`, `git`  | Grundlegende Werkzeuge          |
| `openssh`      | Fernwartung, später auch hilfreich |
| `python3`, `pip`, `npm` | Einstieg ins Programmieren |
| `vscode`       | Beliebter Code-Editor (DEB-Version) |
| `node`, `docker`, `powershell` | Für spätere Tech-Experimente |

---

### Lernen & Bildung
| Tool              | Zweck                           |
|------------------|----------------------------------|
| `gcompris`        | Lernspiele: Mathe, Logik, Sprachen |
| `scratch`         | Visuelles Programmieren mit Bausteinen |
| `kalgebra`, `kgeography`, `kstars` | KDE Edu Suite: Mathe, Geografie, Astronomie |
| `libreoffice`     | Text, Tabellen, Präsentationen  |
| `keepassxc`       | Passwortverwaltung – sicher von Anfang an |

---

### Kreativität (Bild & Video)
| Tool         | Zweck                                |
|--------------|---------------------------------------|
| `krita`      | Digitale Malerei & Zeichnen           |
| `gimp`       | Bildbearbeitung                       |
| `inkscape`   | Vektor-Grafiken                       |
| `blender`    | 3D-Modellierung & Animation           |
| `rawTherapee`  | Fotobearbeitung (RAW-Entwicklung)     |
| `shotwell`   | Bildverwaltung                        |
| `kdenlive`   | Videos schneiden                      |
| `imagemagick`| Kommandozeilen-Bildbearbeitung        |

---

### Audio, Musik & Medien
| Tool        | Zweck                                |
|-------------|---------------------------------------|
| `audacity`  | Audioaufnahme & Bearbeitung           |
| `vlc`       | Universeller Medienplayer             |
| *(Optional: `sonic-pi`, `pipewire`)* | Für Musik-Experimente – kann später nachinstalliert werden |

---

### Kommunikation / Schule


| Tool        | Zweck                                 |
|-------------|----------------------------------------|
| `edge`    | Webbrowser für maximale Office/Teams-Kompatibilität |
| `firefox`    | Webbrowser für privacy|

---

## 🛠️ Nutzung des Installationsscripts

```bash
git clone https://github.com/codegarden13/ubuntu-smartstart-kids.git
cd ubuntu-setup
chmod +x install.sh
./install.sh
```

... oder als ZIP herunterladen und klassisch (1990) herumstöbern. 🎸