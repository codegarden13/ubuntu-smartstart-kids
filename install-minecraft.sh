#!/usr/bin/env bash
# ==========================================
# Minecraft Java Edition Installer for Ubuntu
# ==========================================

set -euo pipefail

# --- Konfiguration ---
URL="https://launcher.mojang.com/download/Minecraft.deb"
PKG="Minecraft.deb"

echo "=== Minecraft Java Installer für Ubuntu ==="
echo "Lade Paket herunter..."

# --- Download ---
wget -O "$PKG" "$URL"

echo "Installiere Paket..."
sudo apt install -y ./"$PKG"

# --- Bereinigung ---
rm "$PKG"

# --- Optional: Java installieren, falls noch nicht vorhanden ---
if ! command -v java >/dev/null 2>&1; then
  echo "Java-Laufzeitumgebung fehlt – wird installiert..."
  sudo apt install -y openjdk-21-jre
fi

echo "✅ Installation abgeschlossen!"
echo "Starte Minecraft mit: minecraft-launcher"
echo "Oder über das Anwendungsmenü → Minecraft Launcher"