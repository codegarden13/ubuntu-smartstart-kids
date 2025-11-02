#!/usr/bin/env bash

# ==========================================
# Google Chrome
# ==========================================
 
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
