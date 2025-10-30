#!/bin/bash



#!/usr/bin/env bash


# ==========================================
# Ubuntu Universal Installer (APT only)
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

# Firefox-Updates aus dem PPA bevorzugen
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee /etc/apt/preferences.d/mozilla-firefox

sudo apt install firefox -y


# Microsoft Edge für Ubuntu installieren (Stable-Version, ohne Snap)

# Logs and temporary output
*.log
*.tmp

# Scripts not ready
_unused/
install-old.sh

# Personal notes or lists
linkliste.txt
inventory.txt

# Editor/project files
.vscode/
*.swp
.DS_Store




# ==========================================
# Chrome
# ===
 
 
 if dpkg -s google-chrome-stable >/dev/null 2>&1; then
    
      else
        echo "Installing Google Chrome..." | tee -a "$LOG_FILE"
        TMP_DIR=$(mktemp -d)
        cd "$TMP_DIR"
        wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        if sudo dpkg -i google-chrome-stable_current_amd64.deb || sudo apt-get -f install -y; then
          echo "chrome successfully installed" | tee -a "$LOG_FILE"
        else
            echo "chrome install failed" 
        cd ~
        rm -rf "$TMP_DIR"
      fi
      ;;
