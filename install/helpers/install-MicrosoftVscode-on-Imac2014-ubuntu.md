# vscode auf Imac 2014 mit Ubuntu

"Glitches" in der Anzeige:

VS Code basiert auf Electron (Chromium) und nutzt standardmäßig:
	•	Hardwarebeschleunigtes Rendering (GPU)
	•	OpenGL / Vulkan über Mesa
	•	Compositing über Mutter / Xorg / Wayland

Das ist ein Treiber-/Compositor-Problem.

```sh
code --disable-gpu # hilft
code --use-gl=desktop # nicht komplett deaktivieren
code --use-gl=swiftshader # langsamer aber stabil
```

Globales Icon-override:

```sh
udo mkdir -p /usr/local/share/applications
sudo cp /usr/share/applications/code.desktop /usr/local/share/applications/
sudo nano /usr/local/share/applications/code.desktop
```