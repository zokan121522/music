#!/bin/bash
# ═══════════════════════════════════════════════════════════
#  CMUS — Sync Favorites View
#  Creates a directory of symlinks with ★ for browsing
#  favorites like a regular folder in cmus browser.
# ═══════════════════════════════════════════════════════════

FAV_FILE="$HOME/.config/cmus/favorites.list"
FAV_VIEW_DIR="$HOME/.config/cmus/favorites-view"

mkdir -p "$FAV_VIEW_DIR"

# Remove old symlinks
find "$FAV_VIEW_DIR" -type l -name "★ *" -delete 2>/dev/null

# If no favorites, leave empty directory
if [ ! -s "$FAV_FILE" ]; then
    exit 0
fi

COUNTER=0

while IFS= read -r filepath; do
    [ -z "$filepath" ] && continue
    [ ! -f "$filepath" ] && continue

    # Extract filename and create symlink with ★ prefix
    BASENAME=$(basename "$filepath")
    LINK_NAME="$FAV_VIEW_DIR/★ $BASENAME"

    # If link already exists and points to correct file, skip
    if [ -L "$LINK_NAME" ] && [ "$(readlink "$LINK_NAME")" = "$filepath" ]; then
        COUNTER=$((COUNTER + 1))
        continue
    fi

    # Create symlink
    ln -sf "$filepath" "$LINK_NAME" 2>/dev/null
    COUNTER=$((COUNTER + 1))

done < "$FAV_FILE"

# Clean up broken symlinks (files that were deleted/moved)
find "$FAV_VIEW_DIR" -type l ! -exec test -e {} \; -delete 2>/dev/null

# Output count for notification (quiet)
echo "$COUNTER favorites synced"
