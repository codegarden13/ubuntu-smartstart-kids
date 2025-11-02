#!/bin/bash
# toggle-app.sh — Toggle install/uninstall of an app (APT-based)
# Usage: ./toggle-app.sh <appname>

APP="$1"

if [[ -z "$APP" ]]; then
    echo "Usage: $0 <appname>"
    exit 1
fi

# Check if the package is installed
if dpkg -s "$APP" &>/dev/null; then
    echo "📦 '$APP' is currently installed."
    read -p "Do you want to uninstall it? [y/N] " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        echo "🚮 Uninstalling $APP..."
        sudo apt remove --purge -y "$APP"
        sudo apt autoremove -y
        echo "✅ $APP has been uninstalled."
    else
        echo "❌ Operation canceled."
    fi
else
    echo "📭 '$APP' is not installed."
    read -p "Do you want to install it? [y/N] " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        echo "📥 Installing $APP..."
        sudo apt update -y
        sudo apt install -y "$APP"
        echo "✅ $APP has been installed."
    else
        echo "❌ Operation canceled."
    fi
fi