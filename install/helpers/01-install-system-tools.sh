#!/usr/bin/env bash
set -e

LOG_FILE="/var/log/software-install.log"

APT_PACKAGES=(
  curl
  openssh-server
  git
  python3
  python3-pip
  npm
  htop
  samba
  apache2
)

install_apt_pkg() {
  local pkg="$1"

  if dpkg -s "$pkg" >/dev/null 2>&1; then
    echo "$pkg is already installed" | tee -a "$LOG_FILE"
  else
    echo "Installing $pkg via APT..." | tee -a "$LOG_FILE"
    if sudo apt-get install -y "$pkg"; then
      add_inventory "$pkg" "apt" "installed"
      echo "Installed $pkg via APT" | tee -a "$LOG_FILE"
    else
      echo "Installing $pkg via APT failed" | tee -a "$LOG_FILE"
    fi
  fi
}

sudo apt-get update

for pkg in "${APT_PACKAGES[@]}"; do
  install_apt_pkg "$pkg"
done