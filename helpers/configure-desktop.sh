#!/usr/bin/env bash
# ==========================================
# Optimize Ubuntu GNOME UI for all users
# ==========================================

set -euo pipefail

echo "=== Ubuntu Oberfläche optimieren ==="

# --- Mauszeigergröße ---
gsettings set org.gnome.desktop.interface cursor-size 48

# --- Schriftgröße ---
gsettings set org.gnome.desktop.interface text-scaling-factor 1.3

# --- Dunkles Design ---
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# --- Tastatur-Wiederholung ---
gsettings set org.gnome.desktop.peripherals.keyboard repeat true
gsettings set org.gnome.desktop.peripherals.keyboard delay 250
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 25

# --- Dock-Favoriten (Beispiel) ---
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop']"

echo "✅ Oberfläche für aktuellen Benutzer optimiert."

