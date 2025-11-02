#!/bin/bash



# ==========================================
# Ubuntu Browsers (stict APT)
# ==========================================

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

sudo apt update

# basics- remove snap (langsam und müllt die Platte zu)

sudo snap remove --purge firefox

sudo snap remove --purge snap-store
sudo snap remove --purge gnome-42-2204
sudo snap remove --purge gtk-common-themes
sudo snap remove --purge bare
sudo snap remove --purge core22
sudo snap remove --purge firmware-updater
sudo apt purge snapd -y # remove snap

sudo rm -rf ~/snap /snap /var/snap /var/lib/snapd /etc/systemd/system/snap*
sudo systemctl daemon-reexec
sudo systemctl daemon-reload

sudo add-apt-repository ppa:mozillateam/ppa -y
sudo apt update

# ==========================================
# Firefox-Updates aus dem PPA bevorzugen
# ==========================================
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee /etc/apt/preferences.d/mozilla-firefox

sudo apt install firefox -y


# ==========================================
# MS Edge für Ubuntu (Stable-Version, ohne Snap)
# ==========================================

# ==========================================
# Installiert Microsoft Edge, falls nicht vorhanden
# Tested on Ubuntu 22.04+
# ==========================================

set -e  # Skript bei Fehlern beenden

# Prüfen, ob Edge bereits installiert ist
if command -v microsoft-edge &> /dev/null; then
    echo "✅ Microsoft Edge ist bereits installiert."
    exit 0
fi

echo "🧭 Microsoft Edge wird installiert ..."

# Repository-Schlüssel und Quelle hinzufügen (falls noch nicht vorhanden)
if [ ! -f /etc/apt/sources.list.d/microsoft-edge.list ]; then
    echo "🔑 Füge Microsoft Edge Repository hinzu ..."
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" | \
        sudo tee /etc/apt/sources.list.d/microsoft-edge.list > /dev/null
fi

# Paketlisten aktualisieren und Edge installieren
echo "📦 Aktualisiere Paketquellen und installiere Edge ..."
sudo apt update -y
sudo apt install -y microsoft-edge-stable

# Prüfen, ob Installation erfolgreich war
if command -v microsoft-edge &> /dev/null; then
    echo "✅ Microsoft Edge wurde erfolgreich installiert!"
else
    echo "❌ Installation fehlgeschlagen. Bitte manuell prüfen."
fi
