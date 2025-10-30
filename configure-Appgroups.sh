#!/bin/bash

CATEGORY_FILE="app-categories.txt"
USER_DESKTOP_DIR="$HOME/.local/share/applications"
SYSTEM_DESKTOP_DIR="/usr/share/applications"

mkdir -p "$USER_DESKTOP_DIR"

if [ ! -f "$CATEGORY_FILE" ]; then
    echo "❌ Datei $CATEGORY_FILE nicht gefunden."
    exit 1
fi

while IFS=: read -r desktop_file new_category; do
    [[ "$desktop_file" =~ ^#.*$ || -z "$desktop_file" || -z "$new_category" ]] && continue

    src_path=""
    if [ -f "$USER_DESKTOP_DIR/$desktop_file" ]; then
        src_path="$USER_DESKTOP_DIR/$desktop_file"
        from="(Benutzer)"
    elif [ -f "$SYSTEM_DESKTOP_DIR/$desktop_file" ]; then
        src_path="$SYSTEM_DESKTOP_DIR/$desktop_file"
        from="(System)"
    else
        echo "⚠️  $desktop_file nicht gefunden."
        continue
    fi

    target_path="$USER_DESKTOP_DIR/$desktop_file"

    if [ "$src_path" != "$target_path" ]; then
        cp "$src_path" "$target_path"
        echo "📄 Kopiert $desktop_file vom $from"
    fi

    current_category=$(grep -m 1 "^Categories=" "$target_path" | cut -d= -f2)

    if [ -n "$current_category" ]; then
        echo "ℹ️  $desktop_file → bestehend: $current_category"
    else
        echo "➕ $desktop_file → hinzugefügt: $new_category"
        sed -i '/^\[Desktop Entry\]/a Categories='"$new_category"';' "$target_path"
    fi
done < "$CATEGORY_FILE"

echo "✅ Kategorienprüfung abgeschlossen."