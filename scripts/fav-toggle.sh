#!/bin/bash
# ═══════════════════════════════════════════════════════════
#  CMUS — Toggle Favorite (★)
#  Adds/removes ★ in the audio file's Comment tag + symlinks
#  Bind to: bind common f push shell ~/music/scripts/fav-toggle.sh
# ═══════════════════════════════════════════════════════════

FAV_FILE="$HOME/.config/cmus/favorites.list"
FAV_PLAYLIST="$HOME/.config/cmus/favorites.pl"
FAV_VIEW_DIR="$HOME/.config/cmus/favorites-view"
CMUS_DIR="$HOME/.config/cmus"
SCRIPTS_DIR="$HOME/music/scripts"
TAG_SCRIPT="$SCRIPTS_DIR/fav-tag.py"

mkdir -p "$CMUS_DIR" "$FAV_VIEW_DIR"
touch "$FAV_FILE"

# Get current song info from cmus
FILE=$(cmus-remote -Q 2>/dev/null | grep '^file ' | sed 's/^file //')

if [ -z "$FILE" ]; then
    osascript -e 'display notification "No song playing" with title "♫ cmus"'
    exit 1
fi

# Extract artist and title for notification
ARTIST=$(cmus-remote -Q 2>/dev/null | grep '^tag artist ' | sed 's/^tag artist //')
TITLE=$(cmus-remote -Q 2>/dev/null | grep '^tag title ' | sed 's/^tag title //')
SONG_INFO="${ARTIST} - ${TITLE}"
[ "$SONG_INFO" = " - " ] && SONG_INFO=$(basename "$FILE")
SAFE_INFO=$(echo "$SONG_INFO" | sed 's/"/\\"/g')

FAVORITED=false

# Toggle favorite status
if grep -Fxq "$FILE" "$FAV_FILE" 2>/dev/null; then
    # --- Remove from favorites ---
    grep -Fxv "$FILE" "$FAV_FILE" > "${FAV_FILE}.tmp" && mv "${FAV_FILE}.tmp" "$FAV_FILE"
    python3 "$TAG_SCRIPT" remove "$FILE" 2>/dev/null
    osascript -e "display notification \"$SAFE_INFO\" with title \"♡ Removed from Favorites\""
else
    # --- Add to favorites ---
    echo "$FILE" >> "$FAV_FILE"
    python3 "$TAG_SCRIPT" add "$FILE" 2>/dev/null
    osascript -e "display notification \"$SAFE_INFO\" with title \"★ Added to Favorites\""
    FAVORITED=true
fi

# Regenerate playlist
awk '{print}' "$FAV_FILE" > "$FAV_PLAYLIST"

# Sync the favorites-view symlink directory
bash "$SCRIPTS_DIR/fav-sync.sh" 2>/dev/null

# Force cmus to refresh and show the ★ in the display
cmus-remote -C "refresh" 2>/dev/null
cmus-remote -C "win-update-cache" 2>/dev/null

# If currently playing this file, seek 0 to force redraw of current track info
if [ "$FAVORITED" = true ]; then
    cmus-remote -C "seek +0" 2>/dev/null
fi

# Clean up temp file
rm -f "${FAV_FILE}.tmp"
