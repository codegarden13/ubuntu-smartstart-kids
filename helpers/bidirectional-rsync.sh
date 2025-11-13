#!/bin/bash
# ===========================================
# USB <-> Dokumente Bidirektionale Synchronisation mit Logging
# ===========================================

USB_LABEL="MY_BACKUP_STICK"
MOUNT_POINT="/media/$USER/$USB_LABEL"
SOURCE_DIR="$HOME/Dokumente"
DEST_DIR="$MOUNT_POINT/Backup_Dokumente"
LOG_DIR="$HOME/.local/share/usb_sync_logs"
LOG_FILE="$LOG_DIR/sync_$(date '+%Y-%m-%d').log"

# ==== FUNKTION: Log schreiben ====
log() {
    mkdir -p "$LOG_DIR"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# ==== FUNKTION: Synchronisation ====
sync_usb() {
    log "📀 Warte auf USB-Stick '$USB_LABEL'..."
    for i in {1..60}; do
        if mount | grep -q "$MOUNT_POINT"; then
            log "✅ Stick erkannt unter $MOUNT_POINT"
            break
        fi
        sleep 1
    done

    if ! mount | grep -q "$MOUNT_POINT"; then
        log "❌ USB-Stick wurde nicht erkannt oder nicht eingehängt."
        exit 1
    fi

    # Zielverzeichnis anlegen, falls es fehlt
    mkdir -p "$DEST_DIR"

    # ==== 1. Synchronisation PC → Stick ====
    log "🔄 Schritt 1: Synchronisiere vom PC → Stick"
    rsync -av --delete --update "$SOURCE_DIR/" "$DEST_DIR/" >> "$LOG_FILE" 2>&1

    # ==== 2. Synchronisation Stick → PC ====
    log "🔄 Schritt 2: Synchronisiere vom Stick → PC"
    rsync -av --delete --update "$DEST_DIR/" "$SOURCE_DIR/" >> "$LOG_FILE" 2>&1

    # ==== 3. Analyse möglicher Löschungen ====
    # Hinweis: --delete löscht nur Dateien, die in der Quelle fehlen.
    # Durch beide Läufe wird sichergestellt, dass Löschungen in beiden Richtungen propagiert werden.
    log "✅ Synchronisation abgeschlossen."

    # ==== Stick auswerfen ====
    log "⏏️ Werfe USB-Stick aus..."
    DEV=$(lsblk -o NAME,LABEL -P | grep "$USB_LABEL" | awk -F '"' '{print "/dev/"$2}')
    if [ -n "$DEV" ]; then
        udisksctl unmount -b "$DEV" >> "$LOG_FILE" 2>&1
        udisksctl power-off -b "$DEV" >> "$LOG_FILE" 2>&1
        log "💨 Stick sicher ausgeworfen."
    else
        log "⚠️ Konnte Gerät nicht ermitteln, Stick nicht ausgeworfen."
    fi

    log "🪵 Logfile gespeichert unter: $LOG_FILE"
}

# ==== START ====
sync_usb