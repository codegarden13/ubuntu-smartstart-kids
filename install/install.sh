#!/usr/bin/env bash
# ==========================================
# Ubuntu Universal Installer (APT + Custom) with JSON Inventory
# ==========================================

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

# --- Timestamped filenames (YYMMDDHH prefix) ---
TIMESTAMP=$(date +"%y%m%d%H")
LOG_FILE="${TIMESTAMP}_install-log.txt"
# --- Initialize files ---

touch "$LOG_FILE"

echo "===== Installation started: $(date) =====" | tee -a "$LOG_FILE"

# --- Ensure system is up-to-date ---
echo "[INFO] Updating system..." | tee -a "$LOG_FILE"
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get autoremove --purge -y
sudo apt-get autoclean -y

# basics- remove snap (langsam und müllt die Platte zu)
# damit muss man zwar den Standard Firefox von Ubuntu rasieren, bekommt aber ein leichteres und klareres System.

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

LIST_FILE="software-list.txt"

# --- Install APT package ---
install_apt_pkg() {
  local pkg="$1"
  if dpkg -s "$pkg" >/dev/null 2>&1; then
    echo "$pkg is already installed" | tee -a "$LOG_FILE"
    
  else
    echo "Installing $pkg via APT..." | tee -a "$LOG_FILE"
    if sudo apt-get install -y "$pkg"; then
      add_inventory "$pkg" "apt" "installed"
      echo "Installed $pkg via APT..." | tee -a "$LOG_FILE"
    else
      echo "Installing $pkg via APT failed..." | tee -a "$LOG_FILE"
    fi
  fi
}

# --- Custom installers ---
install_custom_pkg() {
  local pkg="$1"
  case "$pkg" in
    vscode)
      if dpkg -s code >/dev/null 2>&1; then
        add_inventory "vscode" "custom" "already_installed"
      else
        echo "Installing Visual Studio Code..." | tee -a "$LOG_FILE"
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
        sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | \
          sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
        sudo apt-get update -y
        if sudo apt-get install -y code; then
          add_inventory "vscode" "custom" "installed"
        else
          add_inventory "vscode" "custom" "failed"
        fi
        rm -f microsoft.gpg
      fi
      ;;
    chrome)
      if dpkg -s google-chrome-stable >/dev/null 2>&1; then
        add_inventory "chrome" "custom" "already_installed"
        echo "Skip, chrome is already installed" | tee -a "$LOG_FILE"
      else
        echo "Installing Google Chrome..." | tee -a "$LOG_FILE"
        TMP_DIR=$(mktemp -d)
        cd "$TMP_DIR"
        wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        if sudo dpkg -i google-chrome-stable_current_amd64.deb || sudo apt-get -f install -y; then
          echo "chrome successfully installed" | tee -a "$LOG_FILE"
        else
            echo "chrome install failed" | tee -a "$LOG_FILE"
        fi
        cd ~
        rm -rf "$TMP_DIR"
      fi
      ;;
  ;
   
    
    node)
      if command -v node >/dev/null 2>&1; then
        add_inventory "node/npm" "custom" "already_installed"
      else
        echo "Installing Node.js + npm..." | tee -a "$LOG_FILE"
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        if sudo apt-get install -y nodejs; then
          add_inventory "node/npm" "custom" "installed"
        else
          add_inventory "node/npm" "custom" "failed"
        fi
      fi
      ;;
    powershell)
      if command -v pwsh >/dev/null 2>&1; then
          echo "powershell already installed" | tee -a "$LOG_FILE"
      else
        echo "Installing Microsoft PowerShell..." | tee -a "$LOG_FILE"
        wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb
        sudo dpkg -i packages-microsoft-prod.deb
        rm -f packages-microsoft-prod.deb
        sudo apt-get update -y
        if sudo apt-get install -y powershell; then
           echo "powershell installed" | tee -a "$LOG_FILE"
        else
           echo "powershell install failed" | tee -a "$LOG_FILE"
        fi
      fi
      ;;
    drawio)
      if command -v drawio >/dev/null 2>&1; then
         echo "drawio already installed" | tee -a "$LOG_FILE"
      else
        echo "Installing draw.io (diagrams.net)..." | tee -a "$LOG_FILE"
        TMP_DIR=$(mktemp -d)
        cd "$TMP_DIR"
        wget -q https://github.com/jgraph/drawio-desktop/releases/latest/download/drawio-amd64-24.7.13.deb
        if sudo dpkg -i drawio-amd64-*.deb || sudo apt-get -f install -y; then
           echo "drawio installed" | tee -a "$LOG_FILE"
        else
          echo "drawio install  failed" | tee -a "$LOG_FILE"
        fi
        cd ~
        rm -rf "$TMP_DIR"
      fi
      ;;
    docker)
      if command -v docker >/dev/null 2>&1; then
        add_inventory "docker" "custom" "already_installed"
      else
        echo "Installing Docker Engine..." | tee -a "$LOG_FILE"
        sudo apt-get remove -y docker docker-engine docker.io containerd runc || true
        sudo apt-get install -y ca-certificates curl gnupg lsb-release
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
          https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
          sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update -y
        if sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; then
          sudo usermod -aG docker "$USER"
          add_inventory "docker" "custom" "installed"
        else
          add_inventory "docker" "custom" "failed"
        fi
      fi
      ;;
    *)
      echo "$pkg : unknown custom package" | tee -a "$LOG_FILE"
      add_inventory "$pkg" "custom" "unknown"
      ;;
  esac
}

# --- Main installation loop ---
while read -r line || [[ -n "${line:-}" ]]; do
  # Strip comments and trim spaces
  line="${line%%#*}"
  line="$(echo "$line" | xargs || true)"
  [[ -z "${line:-}" ]] && continue

  if [[ "$line" == custom:* ]]; then
    install_custom_pkg "${line#custom:}"
  else
    install_apt_pkg "$line"
  fi
done < "$LIST_FILE"

# --- Final cleanup ---
echo "[INFO] Cleaning up..." | tee -a "$LOG_FILE"
sudo apt-get autoremove --purge -y
sudo apt-get autoclean -y
sudo apt-get clean

echo "===== Installation completed: $(date) =====" | tee -a "$LOG_FILE"
