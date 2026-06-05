#!/bin/bash
# ═══════════════════════════════════════════════════════════
#  CMUS — Browse Favorites
#  Navigates to the favorites-view symlink directory so you
#  can browse and play favorites like any other folder.
#  Bind to: bind common F push shell ~/music/scripts/fav-load.sh
# ═══════════════════════════════════════════════════════════

FAV_FILE="$HOME/.config/cmus/favorites.list"
FAV_VIEW_DIR="$HOME/.config/cmus/favorites-view"
SCRIPTS_DIR="$HOME/music/scripts"

mkdir -p "$FAV_VIEW_DIR"

# Check if any favorites exist
if [ ! -s "$FAV_FILE" ]; then
    osascript -e 'display notification "No favorites yet. Press f to add songs." with title "♫ cmus"'
    exit 0
fi

# Sync the symlink directory
bash "$SCRIPTS_DIR/fav-sync.sh" 2>/dev/null

# Navigate cmus browser to the favorites view directory
cmus-remote -C "browser-chdir $FAV_VIEW_DIR" 2>/dev/null
sleep 0.3
cmus-remote -C "view 5" 2>/dev/null

SONG_COUNT=$(wc -l < "$FAV_FILE" | tr -d ' ')
osascript -e "display notification \"${SONG_COUNT} favorites — browse and play\" with title \"★ Favorites Folder\""
