#!/bin/bash
# ═══════════════════════════════════════════════════════════
#  CMUS — Toggle Favorite (★)
#  Adds or removes current song from favorites list
#  Bind to: bind common f push shell ~/music/scripts/fav-toggle.sh
# ═══════════════════════════════════════════════════════════

FAV_FILE="$HOME/.config/cmus/favorites.list"
FAV_PLAYLIST="$HOME/.config/cmus/favorites.pl"
CMUS_DIR="$HOME/.config/cmus"

mkdir -p "$CMUS_DIR"
touch "$FAV_FILE"

# Get current song file path from cmus-remote
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
# Escape double quotes for osascript
SAFE_INFO=$(echo "$SONG_INFO" | sed 's/"/\\"/g')

# Toggle favorite status
if grep -Fxq "$FILE" "$FAV_FILE" 2>/dev/null; then
    # --- Remove from favorites ---
    grep -Fxv "$FILE" "$FAV_FILE" > "${FAV_FILE}.tmp" && mv "${FAV_FILE}.tmp" "$FAV_FILE"
    awk '{print}' "$FAV_FILE" > "$FAV_PLAYLIST"
    osascript -e "display notification \"$SAFE_INFO\" with title \"♡ Removed from Favorites\""
else
    # --- Add to favorites ---
    echo "$FILE" >> "$FAV_FILE"
    awk '{print}' "$FAV_FILE" > "$FAV_PLAYLIST"
    osascript -e "display notification \"$SAFE_INFO\" with title \"★ Added to Favorites\""
fi

# Clean up temp file
rm -f "${FAV_FILE}.tmp"
