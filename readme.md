# Ubuntu Setup Scripts

Diese Sammlung von Shell-Skripten automatisiert die Konfiguration eines frischen Ubuntu-Rechners (z. B. für Workstations oder persönliche Setups).

## Inhalt

Dieses Repository enthält ein Installations- und Einrichtungsskript für einen Ubuntu-Rechner, der für ein technisch und künstlerisch interessiertes Kind (ab ca. 10 Jahre) gedacht ist. Es richtet sich an Kinder, die gerne malen, gestalten, experimentieren, programmieren und lernen – und dabei eine moderne, offene Alternative zu Windows/Mac nutzen möchten.

- `install.sh` – Einstiegspunkt für die Installation
- `install-browser.sh` – Installiert Firefox & Chromium
- `configure-desktop.sh` – Passt GNOME-Einstellungen an
- `uninstall.sh` – Entfernt installierte Komponenten
- `inventory.txt` – Übersicht installierter Software
- `_unused/` – Alte oder nicht mehr genutzte Skripte


## 🔐 Sicherheit & Verantwortung
	•	Alle Tools stammen aus offiziellen Quellen oder sind als .deb geprüft eingebunden
	•	Keine automatisierte Konfiguration von Cloud-Logins oder persönlichen Konten
	•	Eltern/Betreuende sollten Installationen einmal manuell überprüfen



## 🎯 Zielgruppe

- **Erstes eigenes Notebook oder Desktop**
- **Kinder und Jugendliche (ca. 10–14 Jahre)**
- Interesse an **Technik, Kunst, Medien, Musik, Programmierung**
- Schulumgebung mit **Microsoft Teams / O365** (Kompatibilität ist berücksichtigt)

## 🔧 Was das Skript macht

- Installiert wichtige **Systemwerkzeuge**
- Fügt kreative, lehrreiche und sichere Software per `apt` hinzu
- Nutzt **nur Paketquellen oder `.deb`-Installationen** – kein Snap, kein Flatpak
- Vermeidet kommerzielle Cloud-Tools, wo möglich.

## 🧩 Software-Auswahl

### System & Entwicklung
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
| `scratch`         | Programmieren mit Bausteinen    |
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
| `darktable`  | Fotobearbeitung (RAW-Entwicklung)     |
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

### Kommunikation & Schule

> ⚠️ Mail-Clients wie `geary` oder `thunderbird` sind **deaktiviert**, da viele Schulen Microsoft 365/Teams verwenden. Web-Apps in Chrome/Firefox sind oft die bessere Lösung für Kinder.

| Tool        | Zweck                                 |
|-------------|----------------------------------------|
| `edge`    | Webbrowser für maximale Office/Teams-Kompatibilität |
| `chrome`    | Webbrowser für Apps |
| `firefox`    | Webbrowser für privacy|

---

## 📦 Struktur

- `install.sh` – zentrales Installationsskript
- Weitere `install-*.sh`-Dateien für Teilinstallationen
- `uninstall.sh` – optionales Deinstallationsskript
- `inventory.txt` – Übersicht der installierten Tools
- `linkliste.txt` – Empfehlungen oder Hilfeseiten

---

## 🛠️ Nutzung

```bash
# Auf einem frischen Ubuntu-System:
git clone https://github.com/<dein-user>/ubuntu-setup.git
cd ubuntu-setup
chmod +x install.sh
./install.sh