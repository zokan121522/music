#!/bin/bash
# ═══════════════════════════════════════════════════════════
#  RETRO WAVE MUSIC PLAYER — LAUNCH MENU
#  Stranger Things Edition
# ═══════════════════════════════════════════════════════════

MUSIC_DIR="$HOME/music"
CMUS_CONFIG="$HOME/.config/cmus/rc"
SCRIPTS_DIR="$MUSIC_DIR/scripts"
DOCS_DIR="$MUSIC_DIR/docs"

show_menu() {
    clear
    echo ""
    echo "  ╔═══════════════════════════════════════╗"
    echo "  ║                                       ║"
    echo "  ║     🎵 RETRO WAVE MUSIC PLAYER       ║"
    echo "  ║     ░ strata░ger thi░gs ░dition       ║"
    echo "  ║                                       ║"
    echo "  ╚═══════════════════════════════════════╝"
    echo ""
    echo "   1) 🎧  Launch cmus"
    echo "   2) 📖  Help & Keybindings"
    echo "   3) ⚙️   Edit Configuration"
    echo "   4) 📂  Browse Music Folders"
    echo "   5) 🔄  Install/Update Dependencies"
    echo "   6) ❌  Quit"
    echo ""
    echo "  ─────────────────────────────────────────"
    echo ""
}

while true; do
    show_menu
    read -p "  Select option [1-6]: " choice

    case $choice in
        1)
            echo ""
            echo "  🎧 Launching cmus..."
            sleep 0.5
            cmus
            echo ""
            echo "  Press Enter to return to menu..."
            read
            ;;
        2)
            if [ -f "$DOCS_DIR/KEYBINDINGS.md" ]; then
                less "$DOCS_DIR/KEYBINDINGS.md"
            else
                echo "  📖 Keybindings:"
                echo "  ─────────────────────────────────────────"
                echo "  Views:    1 Library  2 Sorted  3 Playlist"
                echo "            4 Queue    5 Browser  6 Filters"
                echo ""
                echo "  Playback: p/c Pause   x Play   v Stop"
                echo "            b Next      z Prev"
                echo "            ← → Seek 5s"
                echo ""
                echo "  Volume:   + Up    - Down"
                echo ""
                echo "  List:     a Add    e Queue    Enter Play"
                echo "            D Remove"
                echo ""
                echo "  Modes:    s Shuffle  r Repeat  m Mode"
                echo ""
                echo "  Search:   / Find    n Next"
                echo ""
                echo "  Other:    q Quit    F1 Help"
                echo "  ─────────────────────────────────────────"
                echo ""
                echo "  Press Enter to return to menu..."
                read
            fi
            ;;
        3)
            if command -v nano &>/dev/null; then
                EDITOR="nano"
            elif command -v vim &>/dev/null; then
                EDITOR="vim"
            else
                EDITOR="vi"
            fi
            $EDITOR "$CMUS_CONFIG"
            ;;
        4)
            echo ""
            echo "  📂 Music Folders:"
            echo "  ─────────────────────────────────────────"
            ls -la "$MUSIC_DIR" | grep "^d" | awk '{print "  📁 " $NF}'
            echo ""
            echo "  Full path: $MUSIC_DIR"
            echo ""
            read -p "  Or type a subfolder to browse: " subfolder
            if [ -n "$subfolder" ] && [ -d "$MUSIC_DIR/$subfolder" ]; then
                ls -la "$MUSIC_DIR/$subfolder"
            elif [ -n "$subfolder" ]; then
                echo "  ❌ Folder not found"
            fi
            echo ""
            echo "  Press Enter to return to menu..."
            read
            ;;
        5)
            echo ""
            echo "  🔄 Checking dependencies..."
            if ! command -v cmus &>/dev/null; then
                echo "  Installing cmus..."
                brew install cmus
            else
                echo "  ✅ cmus is installed"
            fi
            echo ""
            echo "  Press Enter to return to menu..."
            read
            ;;
        6)
            echo ""
            echo "  👋 See you, Señor."
            echo ""
            exit 0
            ;;
        *)
            echo ""
            echo "  ❌ Invalid option. Press Enter to try again."
            read
            ;;
    esac
done
