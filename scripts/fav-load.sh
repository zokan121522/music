#!/bin/bash
# ═══════════════════════════════════════════════════════════
#  CMUS — Load Favorites Playlist
#  Loads all favorited songs into cmus playlist view
#  Bind to: bind common F push shell ~/music/scripts/fav-load.sh
# ═══════════════════════════════════════════════════════════

FAV_FILE="$HOME/.config/cmus/favorites.list"
FAV_PLAYLIST="$HOME/.config/cmus/favorites.pl"
CMUS_DIR="$HOME/.config/cmus"

mkdir -p "$CMUS_DIR"

# Check if any favorites exist
if [ ! -s "$FAV_FILE" ]; then
    osascript -e 'display notification "No favorites yet. Press f to add songs." with title "♫ cmus"'
    exit 0
fi

# Regenerate playlist from favorites list
awk '{print}' "$FAV_FILE" > "$FAV_PLAYLIST"

# Load playlist into cmus and switch to playlist view
cmus-remote -C "load $FAV_PLAYLIST" 2>/dev/null
sleep 0.3
cmus-remote -C "view 3" 2>/dev/null

SONG_COUNT=$(wc -l < "$FAV_FILE" | tr -d ' ')
osascript -e "display notification \"${SONG_COUNT} songs loaded\" with title \"★ Favorites Playlist\""
