#!/usr/bin/env bash
# ==========================================
# FF ohne snap
# ==========================================

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