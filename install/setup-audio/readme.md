## Audiokomponenten

Ubuntu verwendet ausschließlich PipeWire als modernes Audiosystem.
JACK und PulseAudio sind nicht mehr “echte” Systeme, sondern werden in PipeWire emuliert.

Ein frisch installiertes Ubuntu 24.04 enthält bereits:

✔ pipewire
✔ pipewire-alsa (ALSA → PipeWire)
✔ pipewire-pulse (PulseAudio → PipeWire)
✔ libpipewire-0.3
✔ gstreamer1.0-pipewire

Du kannst damit sofort:
- USB-Audiointerfaces benutzen
- aufnehmen und abspielen
- Effekte nutzen (Rakarrack, Guitarix usw.)
- Programme mit JACK-Unterstützung verwenden (über Emulation)

➡️ Ohne irgendetwas nachzuinstallieren.

### Details Vanilla ubuntu

| Komponente                          | in Ubuntu 24.04 ? | Aufgabe / Beschreibung                                                                 | Brauche ich das?            |
|-------------------------------------|--------------------------------|-----------------------------------------------------------------------------------------|------------------------------|
| **pipewire**                        | ✔ Ja                           | Zentrale Audio-/Video-Engine. Ersetzt PulseAudio und JACK. Niedrige Latenz, Routing.   | ✔ Ja – Kernsystem            |
| **pipewire-alsa**                   | ✔ Ja                           | ALSA-Programme → PipeWire-Routing. Für alte Apps und Kompatibilität.                   | ✔ Ja – Standard              |
| **pipewire-pulse**                  | ✔ Ja                           | Vollständiger PulseAudio-Ersatz. Firefox, Discord, Audacity nutzen dies automatisch.    | ✔ Ja – sehr wichtig          |
| **libpipewire-0.3-0t64**            | ✔ Ja                           | PipeWire-Bibliotheken, die Apps laden.                                                  | ✔ Ja – Basisbibliotheken     |
| **gstreamer1.0-pipewire**           | ✔ Ja                           | Ermöglicht GStreamer-Apps Sound über PipeWire (Browser, Videoplayer, usw.).             | ✔ Ja – Desktop-Audio         |
| **pipewire-jack**                   | ❌ Nein (veraltet)             | JACK-Kompatibilitätsbibliotheken. In Ubuntu 24.04 inkompatibel → führt zu Fehlern.      | ❌ Nein – nicht installieren  |
| **pipewire-audio-client-libraries** | ✔ optional                     | Alte JACK/ALSA Kompatibilitätslayer. `pw-jack` existiert aber nicht mehr in 24.04.      | ❌ Meist unnötig              |
| **jackd / jackd2**                  | ❌ Nein (nicht mehr nötig)     | Klassischer JACK-Audio-Server. Konflikte mit PipeWire.                                  | ❌ Nein – nicht installieren  |
| **qjackctl**                        | ❌ Nein (nur manuell)          | GUI zur JACK-Steuerung. Unter PipeWire überflüssig, verwirrt Setup.                     | ❌ Nein – nicht installieren  |
| **pulseaudio**                      | ✔ Teils vorhanden              | Wird von PipeWire emuliert. Sollte nicht als Server installiert werden.                 | ❌ Nicht installieren         |
| **alsa-utils**                      | ✔ Ja                           | Grundwerkzeuge wie `alsamixer`.                                                         | ✔ Optional nützlich           |
| **pavucontrol**                     | ❌ Nein (manuell installieren) | GUI zum Routing & Lautstärke (empfohlen für USB-Interfaces).                             | ✔ Ja – sehr empfehlenswert    |
| **helvum**                          | ❌ Nein                        | Node-basierter Audio-Router für PipeWire (Patchbay wie Carla).                          | ✔ Optional bei Musikproduktion |





### cleanup 

```sh
sudo apt remove qjackctl jackd jackd2 jackd2-firewire libjack-jackd2-0 meterbridge jack-capture
sudo apt autoremove
```


### setup

„Gitarre → iRig HD2 → Guitarix (Flatpak) → Audacity“

inkl. richtiges Routing, Monitoring, Pegel, PipeWire?
### pavucontrol
sudo apt install pavucontrol