#!/usr/bin/env bash
# ==========================================
# Ubuntu Uninstaller (APT + Custom) with JSON Inventory
# ==========================================

set -euo pipefail

LIST_FILE="software-list-uninstall.txt"

# --- Timestamped filenames (YYMMDD prefix) ---
TIMESTAMP=$(date +"%y%m%d")
UNINSTALL_LOG="${TIMESTAMP}_uninstall-log.txt"
INVENTORY_FILE="${TIMESTAMP}_uninstall-inventory.json"

echo "[]" > "$INVENTORY_FILE"
touch "$UNINSTALL_LOG"

echo "===== Uninstallation started: $(date) =====" | tee -a "$UNINSTALL_LOG"

# --- Helper: add entry to JSON log ---
add_inventory() {
  local name="$1"
  local type="$2"
  local status="$3"
  jq --arg n "$name" --arg t "$type" --arg s "$status" \
     '. += [{"name": $n, "type": $t, "status": $s, "timestamp": "'"$(date -Iseconds)"'"}]' \
     "$INVENTORY_FILE" > tmp.json && mv tmp.json "$INVENTORY_FILE"
}

# --- Generic uninstall helper ---
remove_app_auto() {
  local app="$1"
  local removed_any=false

  echo "Checking installation source for: $app" | tee -a "$UNINSTALL_LOG"

  # 1️⃣ Check with `which`
  if ! command -v "$app" >/dev/null 2>&1; then
    echo "$app not found in PATH — checking package databases..." | tee -a "$UNINSTALL_LOG"
  fi

  # 2️⃣ APT detection
  if dpkg-query -W -f='${Package}\n' 2>/dev/null | grep -i "^$app" >/dev/null 2>&1; then
    echo "APT package detected for $app — removing..." | tee -a "$UNINSTALL_LOG"
    sudo apt-get remove --purge -y "$app" || true
    removed_any=true
  fi

  # 3️⃣ SNAP detection
  if command -v snap >/dev/null 2>&1 && snap list 2>/dev/null | grep -q "^$app"; then
    echo "Snap package detected for $app — removing..." | tee -a "$UNINSTALL_LOG"
    sudo snap remove "$app" --purge || true
    removed_any=true
  fi

  # 4️⃣ Flatpak detection
  if command -v flatpak >/dev/null 2>&1 && flatpak list 2>/dev/null | grep -q "$app"; then
    echo "Flatpak package detected for $app — removing..." | tee -a "$UNINSTALL_LOG"
    flatpak uninstall -y --delete-data "$app" || true
    removed_any=true
  fi

  # 5️⃣ Cleanup result
  if [[ "$removed_any" == true ]]; then
    add_inventory "$app" "auto" "removed"
  else
    echo "No installation source detected for $app" | tee -a "$UNINSTALL_LOG"
    add_inventory "$app" "auto" "not_installed"
  fi
}

# --- Custom uninstallation blocks ---
remove_custom_pkg() {
  local pkg="$1"
  case "$pkg" in
    vscode)
      echo "Removing Visual Studio Code..." | tee -a "$UNINSTALL_LOG"
      sudo apt-get remove --purge -y code || true
      sudo rm -f /etc/apt/sources.list.d/vscode.list /usr/share/keyrings/microsoft.gpg
      sudo rm -rf ~/.config/Code ~/.vscode
      add_inventory "vscode" "custom" "removed"
      ;;
    chrome)
      echo "Removing Google Chrome..." | tee -a "$UNINSTALL_LOG"
      sudo apt-get remove --purge -y google-chrome-stable || true
      sudo rm -rf /etc/apt/sources.list.d/google-chrome.list /usr/share/keyrings/google-chrome.gpg
      add_inventory "chrome" "custom" "removed"
      ;;
    powershell)
      echo "Removing Microsoft PowerShell..." | tee -a "$UNINSTALL_LOG"
      sudo apt-get remove --purge -y powershell || true
      sudo rm -f /etc/apt/sources.list.d/microsoft-prod.list /usr/share/keyrings/microsoft.gpg
      sudo apt-get autoremove --purge -y
      add_inventory "powershell" "custom" "removed"
      ;;
    keepassxc)
      echo "Removing KeePassXC..." | tee -a "$UNINSTALL_LOG"
      sudo apt-get remove --purge -y keepassxc || true
      add_inventory "keepassxc" "custom" "removed"
      ;;
    node)
      echo "Removing Node.js + npm..." | tee -a "$UNINSTALL_LOG"
      sudo apt-get remove --purge -y nodejs npm || true
      sudo rm -f /etc/apt/sources.list.d/nodesource.list
      add_inventory "node/npm" "custom" "removed"
      ;;
    docker)
      echo "Removing Docker Engine..." | tee -a "$UNINSTALL_LOG"
      sudo systemctl stop docker || true
      sudo apt-get remove --purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || true
      sudo rm -rf /etc/apt/sources.list.d/docker.list /etc/apt/keyrings/docker.gpg
      sudo rm -rf /var/lib/docker /var/lib/containerd
      add_inventory "docker" "custom" "removed"
      ;;
    drawio)
      echo "Removing draw.io (auto-detecting source)..." | tee -a "$UNINSTALL_LOG"
      remove_app_auto "drawio"
      ;;
    libreoffice)
      echo "Removing LibreOffice (APT, Snap, or Flatpak)..." | tee -a "$UNINSTALL_LOG"
      remove_app_auto "libreoffice"
      ;;
    *)
      echo "Unknown custom package: $pkg" | tee -a "$UNINSTALL_LOG"
      add_inventory "$pkg" "custom" "unknown"
      ;;
  esac
}

# --- Main loop ---
while read -r line || [[ -n "${line:-}" ]]; do
  # Strip comments and whitespace
  line="${line%%#*}"
  line="$(echo "$line" | xargs || true)"
  [[ -z "${line:-}" ]] && continue

  if [[ "$line" == custom:* ]]; then
    remove_custom_pkg "${line#custom:}"
  else
    remove_app_auto "$line"
  fi
done < "$LIST_FILE"



# 1. Firefox-Snap entfernen (falls noch nicht getan)
sudo snap remove --purge firefox

# 2. Weitere Snaps entfernen
sudo snap remove --purge firmware-updater
sudo snap remove --purge core22
sudo snap remove --purge bare

# 3. Snap selbst deinstallieren
sudo apt purge snapd

# 4. Snap-Daten löschen
sudo rm -rf ~/snap /var/snap /var/lib/snapd /snap /etc/systemd/system/snap*

# 5. Optional: Autostart-Einträge bereinigen
sudo systemctl daemon-reexec
sudo systemctl daemon-reload

# --- SSH cleanup ---
if dpkg -s openssh-server >/dev/null 2>&1; then
  echo "Stopping and disabling SSH server..." | tee -a "$UNINSTALL_LOG"
  sudo systemctl stop ssh || true
  sudo systemctl disable ssh || true
fi

# --- Final cleanup ---
echo "Running autoremove & clean..." | tee -a "$UNINSTALL_LOG"
sudo apt-get autoremove --purge -y
sudo apt-get autoclean -y
sudo apt-get clean

echo "===== Uninstallation completed: $(date) =====" | tee -a "$UNINSTALL_LOG"