#!/bin/bash
# ═══════════════════════════════════════════════════════════
#  CMUS — Configure Music Path
#  Interactive script to view/change the default music path
# ═══════════════════════════════════════════════════════════

PATH_CONF="$HOME/.config/cmus/music-path.conf"

# Read current path
if [ -f "$PATH_CONF" ]; then
    CURRENT_PATH=$(cat "$PATH_CONF" | head -1)
else
    CURRENT_PATH="$HOME/Music"
fi

while true; do
    clear
    echo "  ╔═══════════════════════════════════════╗"
    echo "  ║    ⚙️  Music Path Configuration       ║"
    echo "  ╚═══════════════════════════════════════╝"
    echo ""
    echo "  Current path:"
    echo "  📂  $CURRENT_PATH"
    echo ""
    echo "  Options:"
    echo "    1) ✏️   Change path"
    echo "    2) 🔄  Reset to default ($HOME/Music)"
    echo "    3) 🔙  Back to menu"
    echo ""
    echo "  ─────────────────────────────────────────"
    echo ""

    read -p "  Select option [1-3]: " choice

    case $choice in
        1)
            echo ""
            echo "  Enter new music path:"
            read -p "  ➜  " NEW_PATH

            # Expand tilde if present
            EVAL_PATH=$(eval echo "$NEW_PATH")

            if [ -d "$EVAL_PATH" ]; then
                echo "$EVAL_PATH" > "$PATH_CONF"
                CURRENT_PATH="$EVAL_PATH"
                echo ""
                echo "  ✅ Path updated successfully!"
                # If cmus is running, navigate there now
                if cmus-remote -Q &>/dev/null; then
                    cmus-remote -C "browser-chdir $EVAL_PATH" 2>/dev/null
                    echo "  📂 cmus navigated to new path"
                fi
            else
                echo ""
                echo "  ❌ Error: Directory does not exist:"
                echo "     $EVAL_PATH"
            fi
            echo ""
            read -p "  Press Enter to continue..."
            ;;
        2)
            DEFAULT_PATH="$HOME/Music"
            echo "$DEFAULT_PATH" > "$PATH_CONF"
            CURRENT_PATH="$DEFAULT_PATH"
            echo ""
            echo "  ✅ Reset to default: $DEFAULT_PATH"
            echo ""
            read -p "  Press Enter to continue..."
            ;;
        3)
            return 0
            ;;
        *)
            echo ""
            echo "  ❌ Invalid option."
            echo ""
            read -p "  Press Enter to try again..."
            ;;
    esac
done
