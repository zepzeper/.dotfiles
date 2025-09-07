#!/bin/bash
PROJECT_PATH="/home/zepzeper/personal/climb/opencode/"
USER="zepzeper"
MAC_IP="192.168.1.99"
MAC_PATH="/Users/zepzeper/personal/ClimbingTrainer/"

# Check if project directory exists
if [ ! -d "$PROJECT_PATH" ]; then
    notify-send "iOS Sync Error" "Project directory does not exist" --icon=dialog-error
    exit 1
fi

# Test SSH connection first
if ! ssh -o ConnectTimeout=5 -o BatchMode=yes "$USER@$MAC_IP" exit 2>/dev/null; then
    notify-send "iOS Sync Error" "Cannot connect to Mac" --icon=dialog-error
    exit 1
fi

echo "Starting initial sync..."

# Init sync
if rsync -avz --delete --exclude='.git/' --exclude='build/' --exclude='DerivedData/' \
  "$PROJECT_PATH" "$USER@$MAC_IP:$MAC_PATH"; then
    notify-send "iOS Sync" "✓ Ready - debugging file events" --icon=folder-sync
    echo "Initial sync completed successfully"
else
    notify-send "iOS Sync" "✗ Initial sync failed" --icon=dialog-error
    exit 1
fi

echo "Starting file watcher (debug mode)..."

# Watch ALL events to see what Neovim actually does
inotifywait -m -r -e modify,attrib,close_write,close_nowrite,moved_to,moved_from,move,create,delete "$PROJECT_PATH" --format '%w%f %e %T' --timefmt='%H:%M:%S' |
while read file event timestamp; do
    echo "[$timestamp] Event: $event on file: $(basename "$file")"
    
    # Skip obvious temp files
    if [[ "$file" == *".swp" ]] || [[ "$file" == *".tmp" ]] || [[ "$file" == *"~" ]]; then
        echo "  -> Skipping temp file"
        continue
    fi
    
    # Only sync on specific events that indicate a real save
    if [[ "$event" == "CLOSE_WRITE" ]] || [[ "$event" == "MOVED_TO" ]] || [[ "$event" == "MODIFY" ]]; then
        filename=$(basename "$file")
        echo "  -> Triggering sync for: $filename"
        
        if rsync -avz --delete --exclude='.git/' --exclude='build/' --exclude='DerivedData/' \
          "$PROJECT_PATH" "$USER@$MAC_IP:$MAC_PATH" >/dev/null 2>&1; then
            notify-send "iOS Sync" "✓ $filename synced ($event)" --icon=folder-sync
        else
            notify-send "iOS Sync" "✗ Sync failed" --icon=dialog-error
        fi
    else
        echo "  -> Ignoring event: $event"
    fi
done
