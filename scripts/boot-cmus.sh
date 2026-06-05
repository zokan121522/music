#!/bin/bash
# ═══════════════════════════════════════════════════════════
#  CMUS — Boot Launcher
#  Starts cmus and navigates to configured music path
#  Called from: LAUNCH.sh option 1
# ═══════════════════════════════════════════════════════════

PATH_CONF="$HOME/.config/cmus/music-path.conf"

# Read configured music path (fallback to home)
if [ -f "$PATH_CONF" ]; then
    MUSIC_PATH=$(cat "$PATH_CONF" | head -1 | tr -d '[:space:]')
else
    MUSIC_PATH="$HOME/Music"
fi

# Launch cmus and navigate to music path in background
clear
echo ""
echo "  ╔═══════════════════════════════════════╗"
echo "  ║     🎵 Launching Retro Wave CMUS     ║"
echo "  ╚═══════════════════════════════════════╝"
echo ""
echo "  📂 Music path: $MUSIC_PATH"
echo ""

# Start cmus in foreground
# A background process waits for cmus to be ready, then navigates
(
    sleep 0.8
    if cmus-remote -Q &>/dev/null; then
        cmus-remote -C "browser-chdir $MUSIC_PATH" 2>/dev/null
    fi
) &

cmus

# Clean up background process when cmus exits
wait 2>/dev/null
