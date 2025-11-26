# Favs import

#!/usr/bin/env bash
# ==========================================
# Import links into Firefox and Chrome bookmarks
# ==========================================

set -euo pipefail

LINKFILE="${1:-linkliste.txt}"
BOOKMARK_HTML="/tmp/imported_links.html"

if [[ ! -f "$LINKFILE" ]]; then
  echo "❌ Datei $LINKFILE nicht gefunden!"
  exit 1
fi

echo "=== Erstelle HTML-Lesezeichen-Datei ==="
cat > "$BOOKMARK_HTML" <<'EOF'
<!DOCTYPE NETSCAPE-Bookmark-file-1>
<!-- This is an automatically generated file. -->
<TITLE>Imported Links</TITLE>
<H1>Imported Links</H1>
<DL><p>
EOF

while IFS= read -r link; do
  [[ -z "$link" ]] && continue
  echo "<DT><A HREF=\"$link\">$link</A>" >> "$BOOKMARK_HTML"
done < "$LINKFILE"

echo "</DL><p>" >> "$BOOKMARK_HTML"

echo "✅ HTML-Datei erstellt: $BOOKMARK_HTML"

# === Firefox ===
echo "📦 Firefox: Import vorbereiten..."
FIREFOX_PROFILE=$(find ~/.mozilla/firefox -maxdepth 1 -type d -name "*.default*" | head -n 1 || true)
if [[ -d "$FIREFOX_PROFILE" ]]; then
  cp "$BOOKMARK_HTML" "$FIREFOX_PROFILE/imported_links.html"
  echo "➡️  Datei im Profilordner gespeichert:"
  echo "   $FIREFOX_PROFILE/imported_links.html"
  echo "   → Öffne Firefox → Lesezeichen → Importieren und Sichern → HTML importieren"
else
  echo "⚠️ Kein Firefox-Profil gefunden!"
fi

# === Chrome ===
echo "📦 Chrome: Import vorbereiten..."
CHROME_BOOKMARK_DIR="$HOME/.config/google-chrome/Default"
if [[ -d "$CHROME_BOOKMARK_DIR" ]]; then
  mkdir -p "$CHROME_BOOKMARK_DIR/Imported"
  cp "$BOOKMARK_HTML" "$CHROME_BOOKMARK_DIR/Imported/imported_links.html"
  echo "➡️  Datei gespeichert unter:"
  echo "   $CHROME_BOOKMARK_DIR/Imported/imported_links.html"
  echo "   → Öffne Chrome → Lesezeichenmanager → Importieren → HTML-Datei auswählen"
else
  echo "⚠️ Kein Chrome-Profil gefunden!"
fi

echo "✅ Fertig! Du kannst die Bookmarks Datei jetzt in beiden Browsern importieren."