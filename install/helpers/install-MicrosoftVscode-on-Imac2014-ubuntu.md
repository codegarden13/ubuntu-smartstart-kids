# vscode - Imac 2014 - Ubuntu

"Glitches" in der Anzeige beseitigen:


```sh
code --disable-gpu # hilft
code --use-gl=desktop # nicht komplett deaktivieren
code --use-gl=swiftshader # langsamer aber stabil
```

## User Desktop Experience

Globales Icon-override:

```sh
sudo mkdir -p /usr/local/share/applications                                  # Wenn es das noch nicht gibt ...
sudo cp /usr/share/applications/code.desktop /usr/local/share/applications/  

```


Vscode-Icon für alle Benutzer: /usr/local/share/applications

```conf

[Desktop Entry]
Name=Visual Studio Code
Comment=Code Editing. Redefined.
GenericName=Text Editor
Exec=/usr/share/code/code --disable-gpu %F
Icon=vscode
Type=Application
StartupNotify=false
StartupWMClass=Code
Categories=TextEditor;Development;IDE;
MimeType=application/x-code-workspace;
Actions=new-empty-window;
Keywords=vscode;

[Desktop Action new-empty-window]
Name=New Empty Window
Name[cs]=Nové prázdné okno
Name[de]=Neues leeres Fenster
Name[es]=Nueva ventana vacía
Name[fr]=Nouvelle fenêtre vide
Name[it]=Nuova finestra vuota
Name[ja]=新しい空のウィンドウ
Name[ko]=새 빈 창
Name[ru]=Новое пустое окно
Name[zh_CN]=新建空窗口
Name[zh_TW]=開新空視窗
Exec=/usr/share/code/code --disable-gpu --new-window %F
Icon=vscode
```